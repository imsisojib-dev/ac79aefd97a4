package com.imsisojib.device_monitor.src.features.devices.data.entities;

import com.imsisojib.device_monitor.src.core.base.entities.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.persistence.*;

@Entity
@Table(name = "devices")
@Data
@EqualsAndHashCode(callSuper = true)
public class DeviceEntity extends BaseEntity {

    @Column(unique = true, length = 100)
    private String deviceId;

    private String model;

    private String brand;

    private String osName;

    private String osVersion;

    @Column(unique = true, length = 200)
    private String androidId;

    @Column(unique = true, length = 200)
    private String identifierForVendor;
}