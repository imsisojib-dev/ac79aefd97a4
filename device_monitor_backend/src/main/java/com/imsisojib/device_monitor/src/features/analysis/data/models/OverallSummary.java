package com.imsisojib.device_monitor.src.features.analysis.data.models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OverallSummary {
    private String deviceCondition;
    private Integer criticalIssues;
    private Integer warnings;
    private Integer improvements;
    private String topRecommendation;
}