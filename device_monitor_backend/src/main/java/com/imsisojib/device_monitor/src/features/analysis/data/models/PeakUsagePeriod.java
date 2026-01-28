package com.imsisojib.device_monitor.src.features.analysis.data.models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PeakUsagePeriod {
    private String timeRange;
    private Integer averageUsage;
    private String frequency;
    private String description;
}