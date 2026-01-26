package com.imsisojib.device_monitor.src.features.devices.services;

import com.imsisojib.device_monitor.src.core.base.exception.ServiceExceptionHolder;
import com.imsisojib.device_monitor.src.core.base.services.BaseService;
import com.imsisojib.device_monitor.src.features.devices.data.dtos.DeviceDto;
import com.imsisojib.device_monitor.src.features.devices.data.entities.DeviceEntity;
import com.imsisojib.device_monitor.src.features.devices.data.repositories.DeviceRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Slf4j
@Service
public class DeviceService extends BaseService<DeviceEntity, DeviceDto> {

    private final DeviceRepository deviceRepository;

    public DeviceService(DeviceRepository deviceRepository) {
        super(deviceRepository);
        this.deviceRepository = deviceRepository;
    }

    @Transactional
    public DeviceDto registerDevice(DeviceDto deviceDto) {
        // Check if device already exists
        Optional<DeviceEntity> existingDevice = Optional.empty();

        if (!utilValidate.noData(deviceDto.getAndroidId())) {
            existingDevice = deviceRepository.findByAndroidIdAndIsDeleted(deviceDto.getAndroidId(), false);
        }

        if (!existingDevice.isPresent() && !utilValidate.noData(deviceDto.getIdentifierForVendor())) {
            existingDevice = deviceRepository.findByIdentifierForVendorAndIsDeleted(deviceDto.getIdentifierForVendor(), false);
        }

        // Return existing device if found
        if (existingDevice.isPresent()) {
            log.info("Device already exists with id: {}", existingDevice.get().getDeviceId());
            return convertForRead(existingDevice.get());
        }

        // Create new device
        DeviceEntity newDevice = convertForCreate(deviceDto);
        newDevice = putBaseEntityDetailsForCreate(newDevice);
        newDevice = deviceRepository.save(newDevice);

        // Generate deviceId using auto-incremented ID
        String deviceId = "DEV" + String.format("%08d", newDevice.getId());
        newDevice.setDeviceId(deviceId);
        // Update the device id
        newDevice = deviceRepository.save(newDevice);

        log.info("New device registered with deviceId: {}", deviceId);
        return convertForRead(newDevice);
    }

    public DeviceDto getDeviceByDeviceId(String deviceId) {
        DeviceEntity device = deviceRepository.findByDeviceIdAndIsDeleted(deviceId, false)
                .orElseThrow(() -> new ServiceExceptionHolder.ResourceNotFoundException(
                        "Device not found with deviceId: " + deviceId));
        return convertForRead(device);
    }

    public DeviceEntity getDeviceEntityByDeviceId(String deviceId) {
        return deviceRepository.findByDeviceIdAndIsDeleted(deviceId, false)
                .orElseThrow(() -> new ServiceExceptionHolder.ResourceNotFoundException(
                        "Device not found with deviceId: " + deviceId));
    }
}