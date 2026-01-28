package com.imsisojib.device_monitor.src.features.analysis.data.dtos;

import com.imsisojib.device_monitor.src.features.analysis.data.models.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VitalsAnalysisResponseDto {
    private String deviceId;
    private AnalyzedPeriod analyzedPeriod;
    private List<Analysis> analyses;
    private OverallSummary overallSummary;
}