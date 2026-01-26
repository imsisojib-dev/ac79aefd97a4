package com.imsisojib.device_monitor.src.features.devices.controllers;

import com.imsisojib.device_monitor.src.core.base.request.BaseRequest;
import com.imsisojib.device_monitor.src.core.base.response.BaseResponse;
import com.imsisojib.device_monitor.src.features.devices.data.dtos.DeviceDto;
import com.imsisojib.device_monitor.src.features.devices.services.DeviceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/devices")
@RequiredArgsConstructor
public class DeviceController {

    private final DeviceService deviceService;

    @PostMapping
    public BaseResponse registerDevice(@RequestBody DeviceDto deviceDto) {
        DeviceDto result = deviceService.registerDevice(deviceDto);
        return BaseResponse.build(HttpStatus.OK)
                .message("Device registered successfully")
                .body(result);
    }

    @PostMapping("/list")
    public BaseResponse getDevices(@RequestBody(required = false) BaseRequest<DeviceDto> request) {
        return deviceService.getList(request);
    }

    @GetMapping("/{deviceId}")
    public BaseResponse getDeviceById(@PathVariable String deviceId) {
        log.info("Get device request received for deviceId: {}", deviceId);
        DeviceDto device = deviceService.getDeviceByDeviceId(deviceId);
        return BaseResponse.build(HttpStatus.OK)
                .message("Device retrieved successfully")
                .body(device);
    }
}