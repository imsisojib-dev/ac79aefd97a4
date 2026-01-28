package com.imsisojib.device_monitor.src.features.analysis.services;

import com.imsisojib.device_monitor.src.core.base.exception.ServiceExceptionHolder;
import com.imsisojib.device_monitor.src.core.base.util.UtilValidate;
import com.imsisojib.device_monitor.src.features.analysis.data.dtos.VitalsAnalysisResponseDto;
import com.imsisojib.device_monitor.src.features.analysis.data.models.*;
import com.imsisojib.device_monitor.src.features.devices.data.entities.DeviceEntity;
import com.imsisojib.device_monitor.src.features.devices.services.DeviceService;
import com.imsisojib.device_monitor.src.features.vitals.data.entities.VitalsEntity;
import com.imsisojib.device_monitor.src.features.vitals.data.repositories.VitalsRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import javax.persistence.criteria.Predicate;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class VitalsAnalysisService {

    private final VitalsRepository vitalsRepository;
    private final DeviceService deviceService;
    private final UtilValidate utilValidate;

    public VitalsAnalysisResponseDto analyzeVitals(String deviceId, String startDate, String endDate) {
        // Check if device exits
        DeviceEntity device = deviceService.getDeviceEntityByDeviceId(deviceId);

        // Parse dates or use defaults (last 90 days)
        LocalDateTime start = parseDate(startDate, LocalDateTime.now().minusDays(90));
        LocalDateTime end = parseDate(endDate, LocalDateTime.now());

        //check if start date is before end date
        if (start.isAfter(end)) {
            throw new ServiceExceptionHolder.BadRequestException("Start date must be before end date");
        }

        // Fetch vitals data
        List<VitalsEntity> vitals = fetchVitals(device, start, end);

        if (vitals.isEmpty()) {
            throw new ServiceExceptionHolder.BadRequestException("No analytics data found for this device");
        }

        // Build analyzed period
        AnalyzedPeriod period = AnalyzedPeriod.builder()
                .startDate(start.toLocalDate().toString())
                .endDate(end.toLocalDate().toString())
                .daysAnalyzed(ChronoUnit.DAYS.between(start.toLocalDate(), end.toLocalDate()))
                .build();

        // Perform analyses
        List<Analysis> analyses = new ArrayList<>();
        
        analyses.add(analyzeDeviceHealth(vitals));
        analyses.add(analyzeBatteryDrain(vitals));
        analyses.add(analyzeThermalThrottling(vitals));
        analyses.add(analyzeMemoryPressure(vitals));

        // Build overall summary
        OverallSummary summary = buildOverallSummary(analyses);

        return VitalsAnalysisResponseDto.builder()
                .deviceId(deviceId)
                .analyzedPeriod(period)
                .analyses(analyses)
                .overallSummary(summary)
                .build();
    }

    private LocalDateTime parseDate(String dateStr, LocalDateTime defaultValue) {
        if (utilValidate.noData(dateStr)) {
            return defaultValue;
        }
        try {
            LocalDate date = LocalDate.parse(dateStr);
            return date.atStartOfDay();
        } catch (Exception e) {
            log.warn("Invalid date format: {}. Using default.", dateStr);
            return defaultValue;
        }
    }

    private List<VitalsEntity> fetchVitals(DeviceEntity device, LocalDateTime start, LocalDateTime end) {
        Specification<VitalsEntity> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("device"), device));
            predicates.add(cb.equal(root.get("isDeleted"), false));
            predicates.add(cb.between(root.get("timestamp"), start, end));
            return cb.and(predicates.toArray(new Predicate[0]));
        };
        return vitalsRepository.findAll(spec);
    }

    private Analysis analyzeDeviceHealth(List<VitalsEntity> vitals) {
        // Calculate component scores (0-100)
        double avgThermal = vitals.stream().mapToInt(VitalsEntity::getThermalStatus).average().orElse(0);
        double avgBattery = vitals.stream().mapToInt(VitalsEntity::getBatteryLevel).average().orElse(0);
        double avgMemory = vitals.stream().mapToInt(VitalsEntity::getMemoryUsage).average().orElse(0);

        // Thermal score (inverted: lower is better)
        int thermalScore = (int) ((3 - avgThermal) / 3.0 * 100);
        
        // Battery score
        int batteryScore = (int) avgBattery;
        
        // Memory score (inverted: lower is better)
        int memoryScore = 100 - (int) avgMemory;

        // Overall health score (weighted average)
        int currentScore = (int) ((thermalScore * 0.3 + batteryScore * 0.4 + memoryScore * 0.3));

        // Calculate previous period score (last 30 days vs previous 30 days)
        int midPoint = vitals.size() / 2;
        List<VitalsEntity> recentHalf = vitals.subList(Math.max(0, midPoint), vitals.size());
        List<VitalsEntity> olderHalf = vitals.subList(0, Math.min(midPoint, vitals.size()));

        int previousScore = calculateHealthScore(olderHalf);
        
        String trend = currentScore > previousScore + 5 ? "IMPROVING" : 
                       currentScore < previousScore - 5 ? "DECLINING" : "STABLE";
        
        double trendPercentage = previousScore > 0 ? 
                ((currentScore - previousScore) / (double) previousScore) * 100 : 0;

        String status = currentScore >= 80 ? "EXCELLENT" : 
                       currentScore >= 60 ? "GOOD" : 
                       currentScore >= 40 ? "FAIR" : "POOR";

        DeviceHealthAnalysis healthData = DeviceHealthAnalysis.builder()
                .currentScore(currentScore)
                .previousScore(previousScore)
                .trend(trend)
                .trendPercentage(Math.round(trendPercentage * 100.0) / 100.0)
                .status(status)
                .breakdown(Map.of(
                        "thermalScore", thermalScore,
                        "batteryScore", batteryScore,
                        "memoryScore", memoryScore
                ))
                .build();

        String description = String.format("Your device health score is %d/100 (%s). ", currentScore, status);
        if (!trend.equals("STABLE")) {
            description += String.format("Score has %s by %.1f%% over the analysis period.", 
                    trend.toLowerCase(), Math.abs(trendPercentage));
        }

        String recommendation = currentScore >= 80 ? 
                "Great! Your device is performing well. Continue current usage patterns." :
                currentScore >= 60 ?
                "Good performance. Monitor thermal and memory usage during peak hours." :
                "Consider optimizing device usage. Focus on reducing thermal stress and memory pressure.";

        return Analysis.builder()
                .type("DEVICE_HEALTH_SCORE")
                .title("Device Health Score & Trend")
                .description(description)
                .severity(status.equals("POOR") || status.equals("FAIR") ? "MEDIUM" : "LOW")
                .recommendation(recommendation)
                .lastUpdated(LocalDateTime.now())
                .data(convertToMap(healthData))
                .build();
    }

    private Analysis analyzeBatteryDrain(List<VitalsEntity> vitals) {
        // Group by day and calculate daily drain
        Map<LocalDate, List<VitalsEntity>> byDay = vitals.stream()
                .collect(Collectors.groupingBy(v -> v.getTimestamp().toLocalDate()));

        List<Integer> dailyDrains = byDay.values().stream()
                .map(dayVitals -> {
                    int maxBattery = dayVitals.stream().mapToInt(VitalsEntity::getBatteryLevel).max().orElse(100);
                    int minBattery = dayVitals.stream().mapToInt(VitalsEntity::getBatteryLevel).min().orElse(0);
                    return maxBattery - minBattery;
                })
                .collect(Collectors.toList());

        int avgDailyDrain = (int) dailyDrains.stream().mapToInt(Integer::intValue).average().orElse(0);
        boolean abnormal = avgDailyDrain > 50;

        // Analyze by time period
        List<PeriodDrain> periodInsights = analyzeBatteryByPeriod(vitals);

        // Find peak drain days
        List<PeakDrainDay> peakDays = byDay.entrySet().stream()
                .map(entry -> {
                    List<VitalsEntity> dayVitals = entry.getValue();
                    int drain = dayVitals.stream().mapToInt(VitalsEntity::getBatteryLevel).max().orElse(100) -
                                dayVitals.stream().mapToInt(VitalsEntity::getBatteryLevel).min().orElse(0);
                    double avgThermal = dayVitals.stream().mapToInt(VitalsEntity::getThermalStatus).average().orElse(0);
                    double avgMemory = dayVitals.stream().mapToInt(VitalsEntity::getMemoryUsage).average().orElse(0);
                    
                    String reason = "";
                    if (avgThermal > 2) reason = String.format("Elevated thermal status (avg: %.1f)", avgThermal);
                    if (avgMemory > 80) {
                        reason += (reason.isEmpty() ? "" : " and ") + String.format("high memory usage (avg: %.0f%%)", avgMemory);
                    }
                    if (reason.isEmpty()) reason = "Normal usage patterns";
                    
                    return PeakDrainDay.builder()
                            .date(entry.getKey().toString())
                            .drainPercentage(drain)
                            .reason(reason)
                            .build();
                })
                .sorted((a, b) -> b.getDrainPercentage().compareTo(a.getDrainPercentage()))
                .limit(3)
                .collect(Collectors.toList());

        BatteryDrainAnalysis batteryData = BatteryDrainAnalysis.builder()
                .averageDailyDrain(avgDailyDrain)
                .abnormalDrainDetected(abnormal)
                .insights(periodInsights)
                .peakDrainDays(peakDays)
                .build();

        String severity = avgDailyDrain > 60 ? "HIGH" : avgDailyDrain > 40 ? "MEDIUM" : "LOW";
        String description = abnormal ? 
                String.format("Battery drains rapidly with an average of %d%% per day.", avgDailyDrain) :
                String.format("Battery drain is normal at %d%% per day on average.", avgDailyDrain);

        String recommendation = avgDailyDrain > 50 ?
                "High battery drain detected. Close background apps and reduce screen brightness." :
                "Battery performance is acceptable. Continue monitoring usage patterns.";

        return Analysis.builder()
                .type("BATTERY_DRAIN_ANALYSIS")
                .title("Battery Drain Analysis")
                .description(description)
                .severity(severity)
                .recommendation(recommendation)
                .lastUpdated(LocalDateTime.now())
                .data(convertToMap(batteryData))
                .build();
    }

    private List<PeriodDrain> analyzeBatteryByPeriod(List<VitalsEntity> vitals) {
        Map<String, List<VitalsEntity>> byPeriod = vitals.stream()
                .collect(Collectors.groupingBy(v -> {
                    int hour = v.getTimestamp().getHour();
                    if (hour >= 6 && hour < 12) return "Morning (6 AM - 12 PM)";
                    if (hour >= 12 && hour < 18) return "Afternoon (12 PM - 6 PM)";
                    if (hour >= 18 && hour < 24) return "Evening (6 PM - 12 AM)";
                    return "Night (12 AM - 6 AM)";
                }));

        return byPeriod.entrySet().stream()
                .map(entry -> {
                    List<VitalsEntity> periodVitals = entry.getValue();
                    int avgDrain = (int) periodVitals.stream()
                            .mapToInt(VitalsEntity::getBatteryLevel)
                            .average().orElse(0);
                    
                    String status = avgDrain < 30 ? "CRITICAL" : avgDrain < 50 ? "LOW" : 
                                   avgDrain < 70 ? "NORMAL" : "OPTIMAL";
                    
                    double avgMemory = periodVitals.stream()
                            .mapToInt(VitalsEntity::getMemoryUsage).average().orElse(0);
                    
                    String correlation = avgMemory > 80 ? 
                            "High memory usage detected during this period" : null;
                    
                    return PeriodDrain.builder()
                            .period(entry.getKey())
                            .averageDrain(100 - avgDrain)
                            .status(status)
                            .correlation(correlation)
                            .build();
                })
                .collect(Collectors.toList());
    }

    private Analysis analyzeThermalThrottling(List<VitalsEntity> vitals) {
        long criticalEvents = vitals.stream().filter(v -> v.getThermalStatus() >= 2).count();
        double avgThermal = vitals.stream().mapToInt(VitalsEntity::getThermalStatus).average().orElse(0);

        Map<String, Integer> distribution = new HashMap<>();
        distribution.put("cool", (int) vitals.stream().filter(v -> v.getThermalStatus() == 0).count());
        distribution.put("nominal", (int) vitals.stream().filter(v -> v.getThermalStatus() == 1).count());
        distribution.put("warm", (int) vitals.stream().filter(v -> v.getThermalStatus() == 2).count());
        distribution.put("hot", (int) vitals.stream().filter(v -> v.getThermalStatus() == 3).count());

        // Find critical thermal events
        List<CriticalEvent> events = vitals.stream()
                .filter(v -> v.getThermalStatus() == 3)
                .limit(5)
                .map(v -> CriticalEvent.builder()
                        .date(v.getTimestamp().toLocalDate().toString())
                        .time(v.getTimestamp().toLocalTime().toString())
                        .thermalStatus(v.getThermalStatus())
                        .duration("Estimated 30-60 minutes")
                        .impact("Potential performance throttling detected")
                        .build())
                .collect(Collectors.toList());

        ThermalAnalysis thermalData = ThermalAnalysis.builder()
                .criticalThermalEvents(events.size())
                .averageThermalStatus(Math.round(avgThermal * 100.0) / 100.0)
                .thermalDistribution(distribution)
                .patterns(new ArrayList<>())
                .criticalEvents(events)
                .build();

        String severity = avgThermal > 2 ? "HIGH" : avgThermal > 1 ? "MEDIUM" : "LOW";
        int warmHotPercentage = (distribution.get("warm") + distribution.get("hot")) * 100 / vitals.size();
        
        String description = warmHotPercentage < 10 ?
                String.format("Your device rarely overheats. Only %d%% of readings showed elevated temperature.", warmHotPercentage) :
                String.format("Device shows frequent thermal issues. %d%% of readings indicate warm or hot status.", warmHotPercentage);

        String recommendation = avgThermal > 1.5 ?
                "Reduce intensive tasks and ensure proper ventilation. Consider closing background apps." :
                "Thermal performance is good. Continue monitoring during intensive tasks.";

        return Analysis.builder()
                .type("THERMAL_THROTTLING_ALERTS")
                .title("Thermal Throttling Analysis")
                .description(description)
                .severity(severity)
                .recommendation(recommendation)
                .lastUpdated(LocalDateTime.now())
                .data(convertToMap(thermalData))
                .build();
    }

    private Analysis analyzeMemoryPressure(List<VitalsEntity> vitals) {
        int avgMemory = (int) vitals.stream().mapToInt(VitalsEntity::getMemoryUsage).average().orElse(0);
        int peakMemory = vitals.stream().mapToInt(VitalsEntity::getMemoryUsage).max().orElse(0);
        int highPressure = (int) ((vitals.stream().filter(v -> v.getMemoryUsage() > 80).count() * 100.0) / vitals.size());

        Map<String, Integer> distribution = new HashMap<>();
        distribution.put("optimal", (int) vitals.stream().filter(v -> v.getMemoryUsage() < 50).count());
        distribution.put("moderate", (int) vitals.stream().filter(v -> v.getMemoryUsage() >= 50 && v.getMemoryUsage() < 70).count());
        distribution.put("high", (int) vitals.stream().filter(v -> v.getMemoryUsage() >= 70 && v.getMemoryUsage() < 90).count());
        distribution.put("critical", (int) vitals.stream().filter(v -> v.getMemoryUsage() >= 90).count());

        // Calculate trends
        int third = vitals.size() / 3;
        int last7Days = (int) vitals.subList(Math.max(0, vitals.size() - third), vitals.size()).stream()
                .mapToInt(VitalsEntity::getMemoryUsage).average().orElse(0);
        int last30Days = avgMemory;
        int last90Days = (int) vitals.stream().mapToInt(VitalsEntity::getMemoryUsage).average().orElse(0);

        String trend = Math.abs(last7Days - last30Days) < 5 ? "STABLE" :
                      last7Days > last30Days ? "INCREASING" : "DECREASING";

        MemoryTrend memoryTrend = MemoryTrend.builder()
                .last7Days(last7Days)
                .last30Days(last30Days)
                .last90Days(last90Days)
                .trend(trend)
                .build();

        MemoryPressureAnalysis memoryData = MemoryPressureAnalysis.builder()
                .averageMemoryUsage(avgMemory)
                .peakMemoryUsage(peakMemory)
                .highPressurePercentage(highPressure)
                .usageDistribution(distribution)
                .trends(memoryTrend)
                .peakUsagePeriods(new ArrayList<>())
                .correlations(new ArrayList<>())
                .build();

        String severity = avgMemory > 80 ? "HIGH" : avgMemory > 60 ? "MEDIUM" : "LOW";
        String description = avgMemory > 70 ?
                String.format("Memory usage is high at %d%% average, with %d%% of time under pressure.", avgMemory, highPressure) :
                String.format("Memory usage is healthy at %d%% average.", avgMemory);

        String recommendation = avgMemory > 70 ?
                "Clear app cache and close unused apps regularly to free up memory." :
                "Memory usage is optimal. No immediate action required.";

        return Analysis.builder()
                .type("MEMORY_PRESSURE_INSIGHTS")
                .title("Memory Pressure Insights")
                .description(description)
                .severity(severity)
                .recommendation(recommendation)
                .lastUpdated(LocalDateTime.now())
                .data(convertToMap(memoryData))
                .build();
    }

    private int calculateHealthScore(List<VitalsEntity> vitals) {
        if (vitals.isEmpty()) return 0;
        
        double avgThermal = vitals.stream().mapToInt(VitalsEntity::getThermalStatus).average().orElse(0);
        double avgBattery = vitals.stream().mapToInt(VitalsEntity::getBatteryLevel).average().orElse(0);
        double avgMemory = vitals.stream().mapToInt(VitalsEntity::getMemoryUsage).average().orElse(0);

        int thermalScore = (int) ((3 - avgThermal) / 3.0 * 100);
        int batteryScore = (int) avgBattery;
        int memoryScore = 100 - (int) avgMemory;

        return (int) ((thermalScore * 0.3 + batteryScore * 0.4 + memoryScore * 0.3));
    }

    private OverallSummary buildOverallSummary(List<Analysis> analyses) {
        long criticalIssues = analyses.stream().filter(a -> "HIGH".equals(a.getSeverity())).count();
        long warnings = analyses.stream().filter(a -> "MEDIUM".equals(a.getSeverity())).count();
        long improvements = analyses.stream()
                .filter(a -> a.getData().containsKey("trend") && "IMPROVING".equals(a.getData().get("trend")))
                .count();

        String condition = criticalIssues > 0 ? "NEEDS_ATTENTION" :
                          warnings > 1 ? "FAIR" :
                          warnings > 0 ? "GOOD" : "EXCELLENT";

        String topRecommendation = analyses.stream()
                .filter(a -> "HIGH".equals(a.getSeverity()) || "MEDIUM".equals(a.getSeverity()))
                .findFirst()
                .map(Analysis::getRecommendation)
                .orElse("Your device is performing well. Keep up the good work!");

        return OverallSummary.builder()
                .deviceCondition(condition)
                .criticalIssues((int) criticalIssues)
                .warnings((int) warnings)
                .improvements((int) improvements)
                .topRecommendation(topRecommendation)
                .build();
    }

    private Map<String, Object> convertToMap(Object obj) {
        Map<String, Object> map = new HashMap<>();
        try {
            java.beans.BeanInfo info = java.beans.Introspector.getBeanInfo(obj.getClass());
            for (java.beans.PropertyDescriptor pd : info.getPropertyDescriptors()) {
                if (!"class".equals(pd.getName())) {
                    Object value = pd.getReadMethod().invoke(obj);
                    if (value != null) {
                        map.put(pd.getName(), value);
                    }
                }
            }
        } catch (Exception e) {
            log.error("Error converting object to map", e);
        }
        return map;
    }
}