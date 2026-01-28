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
public class ThermalAnalysis {
    private Integer criticalThermalEvents;
    private Double averageThermalStatus;
    private Map<String, Integer> thermalDistribution;
    private List<ThermalPattern> patterns;
    private List<CriticalEvent> criticalEvents;
}