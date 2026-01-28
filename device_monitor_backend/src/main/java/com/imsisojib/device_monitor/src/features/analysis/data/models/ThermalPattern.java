package com.imsisojib.device_monitor.src.features.analysis.data.models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ThermalPattern {
    private String pattern;
    private String frequency;
    private String timeRange;
    private Double averageThermal;
    private String description;
    private List<String> correlatedFactors;
}