package com.imsisojib.device_monitor.src.features.vitals.controllers;

import com.imsisojib.device_monitor.src.core.base.request.BaseRequest;
import com.imsisojib.device_monitor.src.core.base.response.BaseResponse;
import com.imsisojib.device_monitor.src.features.vitals.data.dtos.VitalsDto;
import com.imsisojib.device_monitor.src.features.vitals.services.VitalsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/vitals")
@RequiredArgsConstructor
public class VitalsController {

    private final VitalsService vitalsService;

    @PostMapping
    public ResponseEntity<BaseResponse> saveVitals(@RequestBody VitalsDto vitalsDto) {
        log.info("Save vitals request received");
        VitalsDto result = vitalsService.saveVitals(vitalsDto);
        return ResponseEntity.ok(
                BaseResponse.build(HttpStatus.OK)
                        .message("Vitals data saved successfully")
                        .body(result)
        );
    }

    @PostMapping("/{deviceId}")
    public ResponseEntity<BaseResponse> getVitalsByDevice(
            @PathVariable String deviceId,
            @RequestBody(required = false) BaseRequest<VitalsDto> request) {

        log.info("Get vitals request received for deviceId: {}", deviceId);

        if (request == null) {
            request = new BaseRequest<>();
        }

        BaseResponse response = vitalsService.getVitalsByDeviceId(deviceId, request);
        return ResponseEntity.ok(response);
    }
}