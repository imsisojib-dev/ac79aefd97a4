package com.imsisojib.device_monitor.src.features.vitals.services;

import com.imsisojib.device_monitor.src.core.base.exception.ServiceExceptionHolder;
import com.imsisojib.device_monitor.src.core.base.request.BaseRequest;
import com.imsisojib.device_monitor.src.core.base.response.BaseResponse;
import com.imsisojib.device_monitor.src.core.base.services.BaseService;
import com.imsisojib.device_monitor.src.features.devices.data.entities.DeviceEntity;
import com.imsisojib.device_monitor.src.features.devices.services.DeviceService;
import com.imsisojib.device_monitor.src.features.vitals.data.dtos.VitalsDto;
import com.imsisojib.device_monitor.src.features.vitals.data.entities.VitalsEntity;
import com.imsisojib.device_monitor.src.features.vitals.data.repositories.VitalsRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import javax.persistence.criteria.Predicate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
public class VitalsService extends BaseService<VitalsEntity, VitalsDto> {

    private final VitalsRepository vitalsRepository;
    
    @Autowired
    private DeviceService deviceService;

    public VitalsService(VitalsRepository vitalsRepository) {
        super(vitalsRepository);
        this.vitalsRepository = vitalsRepository;
    }

    @Override
    protected boolean isValidWhileCreate(VitalsDto dto) {
        //check if deviceId is valid
        if(utilValidate.noData(dto.getDeviceId())){
            throw new ServiceExceptionHolder.ResourceNotFoundException("No device found with id: " + dto.getDeviceId());
        }

        // Validate thermal status (0-3)
        if (dto.getThermalStatus() == null || dto.getThermalStatus() < 0 || dto.getThermalStatus() > 3) {
            throw new ServiceExceptionHolder.BadRequestException("Thermal status must be between 0 and 3");
        }

        // Validate battery level (0-100)
        if (dto.getBatteryLevel() == null || dto.getBatteryLevel() < 0 || dto.getBatteryLevel() > 100) {
            throw new ServiceExceptionHolder.BadRequestException("Battery level must be between 0 and 100");
        }

        // Validate memory usage (0-100)
        if (dto.getMemoryUsage() == null || dto.getMemoryUsage() < 0 || dto.getMemoryUsage() > 100) {
            throw new ServiceExceptionHolder.BadRequestException("Memory usage must be between 0 and 100");
        }

        // Validate timestamp
        if (dto.getTimestamp() == null) {
            throw new ServiceExceptionHolder.BadRequestException("Timestamp is required");
        }

        return true;
    }

    @Transactional
    public VitalsDto saveVitals(VitalsDto vitalsDto) {
        // Validate
        if (!isValidWhileCreate(vitalsDto)) {
            throw new ServiceExceptionHolder.BadRequestException("Invalid vitals data");
        }

        // Get device entity
        DeviceEntity device = deviceService.getDeviceEntityByDeviceId(vitalsDto.getDeviceId());

        // Create vitals entity
        VitalsEntity vitalsEntity = convertForCreate(vitalsDto);
        vitalsEntity.setDevice(device);
        vitalsEntity = putBaseEntityDetailsForCreate(vitalsEntity);

        // Save
        vitalsEntity = vitalsRepository.save(vitalsEntity);

        log.info("Vitals saved for device: {}", device.getDeviceId());
        return convertForRead(vitalsEntity);
    }

    public BaseResponse getVitalsByDeviceId(String deviceId, BaseRequest<VitalsDto> request) {
        // Get device
        DeviceEntity device = deviceService.getDeviceEntityByDeviceId(deviceId);

        // Build specification with filters
        Specification<VitalsEntity> spec = buildSpecificationForDevice(device, request);

        // Check if pagination is needed
        boolean hasMetaData = request.getMeta() != null 
                && request.getMeta().getLimit() != null 
                && request.getMeta().getPage() != null;

        if (hasMetaData) {
            Pageable pageable = getPageable(request.getMeta());
            Page<VitalsEntity> page = vitalsRepository.findAll(spec, pageable);
            return BaseResponse.build(HttpStatus.OK)
                    .meta(getMeta(request.getMeta(), page))
                    .body(convertForRead(page.getContent()));
        } else {
            List<VitalsEntity> results = vitalsRepository.findAll(spec);
            return BaseResponse.build(HttpStatus.OK).body(convertForRead(results));
        }
    }

    private Specification<VitalsEntity> buildSpecificationForDevice(DeviceEntity device, BaseRequest<VitalsDto> request) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            // Filter by device
            predicates.add(cb.equal(root.get("device"), device));

            // Filter by isDeleted
            predicates.add(cb.equal(root.get("isDeleted"), false));

            // Apply additional filters from request body if present
            if (request.getBody() != null) {
                VitalsDto filter = request.getBody();

                // Date range filter
                if (filter.getDateRangeFilter1() != null 
                        && filter.getDateRangeFilter1().getStartDate() != null 
                        && filter.getDateRangeFilter1().getEndDate() != null) {
                    
                    LocalDateTime startDate = LocalDateTime.parse(
                        filter.getDateRangeFilter1().getStartDate() + "T00:00:00"
                    );
                    LocalDateTime endDate = LocalDateTime.parse(
                        filter.getDateRangeFilter1().getEndDate() + "T23:59:59"
                    );
                    
                    predicates.add(cb.between(root.get("timestamp"), startDate, endDate));
                }

                // Filter by thermal status
                if (filter.getThermalStatus() != null) {
                    predicates.add(cb.equal(root.get("thermalStatus"), filter.getThermalStatus()));
                }

                // Filter by battery level range (optional: add min/max battery level filtering)
                if (filter.getBatteryLevel() != null) {
                    predicates.add(cb.equal(root.get("batteryLevel"), filter.getBatteryLevel()));
                }

                // Filter by memory usage range
                if (filter.getMemoryUsage() != null) {
                    predicates.add(cb.equal(root.get("memoryUsage"), filter.getMemoryUsage()));
                }
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}