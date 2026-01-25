package com.imsisojib.device_monitor.src.features.device_vitals.controllers;

import com.imsisojib.device_monitor.src.core.base.response.BaseResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/vitals")
public class DeviceVitalsLogController {

    @GetMapping
    public ResponseEntity<BaseResponse> getAll() {
        return ResponseEntity.ok(
                BaseResponse.build(HttpStatus.OK)
        );
    }
}
