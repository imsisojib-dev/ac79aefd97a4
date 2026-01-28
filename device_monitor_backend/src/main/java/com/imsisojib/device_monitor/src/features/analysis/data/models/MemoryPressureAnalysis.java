package com.imsisojib.device_monitor.src.features.analysis.data.models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MemoryPressureAnalysis {
    private Integer averageMemoryUsage;
    private Integer peakMemoryUsage;
    private Integer highPressurePercentage;
    private Map<String, Integer> usageDistribution;
    private MemoryTrend trends;
    private List<PeakUsagePeriod> peakUsagePeriods;
    private List<Correlation> correlations;
}