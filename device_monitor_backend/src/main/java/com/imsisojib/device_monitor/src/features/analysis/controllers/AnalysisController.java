package com.imsisojib.device_monitor.src.features.analysis.controllers;

import com.imsisojib.device_monitor.src.core.base.request.BaseRequest;
import com.imsisojib.device_monitor.src.core.base.response.BaseResponse;
import com.imsisojib.device_monitor.src.features.analysis.data.dtos.VitalsAnalysisResponseDto;
import com.imsisojib.device_monitor.src.features.analysis.services.VitalsAnalysisService;
import com.imsisojib.device_monitor.src.features.devices.data.dtos.DeviceDto;
import com.imsisojib.device_monitor.src.features.devices.services.DeviceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/analysis")
@RequiredArgsConstructor
public class AnalysisController {

    private final VitalsAnalysisService vitalsAnalysisService;

    @GetMapping("/{deviceId}")
    public BaseResponse getVitalsAnalysis(
            @PathVariable String deviceId,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {

        log.info("Get vitals analysis request received for deviceId: {}", deviceId);

        return BaseResponse.build(HttpStatus.OK)
                .message("Analysis retrieved successfully")
                .body(vitalsAnalysisService.analyzeVitals(deviceId, startDate, endDate));
    }
}