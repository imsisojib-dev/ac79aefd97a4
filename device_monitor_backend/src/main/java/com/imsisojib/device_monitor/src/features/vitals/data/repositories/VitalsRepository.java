package com.imsisojib.device_monitor.src.features.vitals.data.repositories;

import com.imsisojib.device_monitor.src.core.base.repositories.BaseRepository;
import com.imsisojib.device_monitor.src.features.devices.data.entities.DeviceEntity;
import com.imsisojib.device_monitor.src.features.vitals.data.entities.VitalsEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

@Repository
public interface VitalsRepository extends BaseRepository<VitalsEntity> {

    Page<VitalsEntity> findByDeviceAndIsDeleted(DeviceEntity device, boolean isDeleted, Pageable pageable);
}