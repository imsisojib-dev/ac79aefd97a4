package com.imsisojib.device_monitor.src.features.vitals.data.entities;

import com.imsisojib.device_monitor.src.core.base.entities.BaseEntity;
import com.imsisojib.device_monitor.src.features.devices.data.entities.DeviceEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "vitals")
@Data
@EqualsAndHashCode(callSuper = true)
public class VitalsEntity extends BaseEntity {

    @Column(nullable = false)
    private Integer thermalStatus; // 0-3

    @Column(nullable = false)
    private Integer batteryLevel; // 0-100

    @Column(nullable = false)
    private Integer memoryUsage; // 0-100

    @Column(nullable = false)
    private LocalDateTime timestamp;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "device_id", nullable = false)
    private DeviceEntity device;
}