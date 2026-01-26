package com.imsisojib.device_monitor.src.features.vitals.data.dtos;

import com.imsisojib.device_monitor.src.core.base.dtos.BaseDto;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = true)
public class VitalsDto extends BaseDto {

    private Integer thermalStatus;
    private Integer batteryLevel;
    private Integer memoryUsage;
    private LocalDateTime timestamp;
    private String deviceId;
}