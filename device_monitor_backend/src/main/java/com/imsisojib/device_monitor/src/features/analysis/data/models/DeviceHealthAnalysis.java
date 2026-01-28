package com.imsisojib.device_monitor.src.features.analysis.data.models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DeviceHealthAnalysis {
    private Integer currentScore;
    private Integer previousScore;
    private String trend;
    private Double trendPercentage;
    private String status;
    private Map<String, Integer> breakdown;
}