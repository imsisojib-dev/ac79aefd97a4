package com.imsisojib.device_monitor.src.core.base.dtos;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

import java.time.LocalDateTime;


@Data
public abstract class BaseDto {

    private Long id;

    private String createdBy;

    private LocalDateTime createdAt;

    private String updatedBy;

    private LocalDateTime updatedAt;

    @JsonIgnore
    private Boolean isDeleted;

    @JsonIgnore
    private DateRangeFilterDto dateRangeFilter1;

    @JsonIgnore
    private DateRangeFilterDto dateRangeFilter2;

    @JsonIgnore
    private DateRangeFilterDto dateRangeFilter3;

    @JsonIgnore
    private DateRangeFilterDto dateRangeFilter4;
}
