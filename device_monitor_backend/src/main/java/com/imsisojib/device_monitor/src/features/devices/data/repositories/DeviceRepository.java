package com.imsisojib.device_monitor.src.features.devices.data.repositories;

import com.imsisojib.device_monitor.src.core.base.repositories.BaseRepository;
import com.imsisojib.device_monitor.src.features.devices.data.entities.DeviceEntity;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface DeviceRepository extends BaseRepository<DeviceEntity> {

    Optional<DeviceEntity> findByAndroidIdAndIsDeleted(String androidId, boolean isDeleted);
    
    Optional<DeviceEntity> findByIdentifierForVendorAndIsDeleted(String identifierForVendor, boolean isDeleted);
    
    Optional<DeviceEntity> findByDeviceIdAndIsDeleted(String deviceId, boolean isDeleted);

}