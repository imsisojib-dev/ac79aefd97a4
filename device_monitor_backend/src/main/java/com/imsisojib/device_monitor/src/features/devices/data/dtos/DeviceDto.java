package com.imsisojib.device_monitor.src.features.devices.data.dtos;

import com.imsisojib.device_monitor.src.core.base.dtos.BaseDto;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class DeviceDto extends BaseDto {

    private String deviceId;
    private String model;
    private String brand;
    private String osName;
    private String osVersion;
    private String androidId;
    private String identifierForVendor;

}