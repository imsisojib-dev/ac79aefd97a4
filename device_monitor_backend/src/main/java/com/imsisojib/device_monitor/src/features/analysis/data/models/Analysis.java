package com.imsisojib.device_monitor.src.features.analysis.data.models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Analysis {
    private String type;
    private String title;
    private String description;
    private String severity;
    private String recommendation;
    private LocalDateTime lastUpdated;
    private Map<String, Object> data;
}