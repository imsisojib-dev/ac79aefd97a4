package com.imsisojib.device_monitor.src.core.base.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.stereotype.Component;

import javax.persistence.*;
import java.time.LocalDateTime;

@Component
@MappedSuperclass
@Data
public class BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, updatable = false, length = 50)
    private String createdBy;

    @Column(nullable = false, updatable = false)
    @CreatedDate
    private LocalDateTime createdAt;

    @Column(length = 50)
    private String updatedBy;

    @LastModifiedDate
    private LocalDateTime updatedAt;

    @Column(columnDefinition = "boolean DEFAULT false", nullable = false)
    private Boolean isDeleted;

    @JsonIgnore
    private LocalDateTime deletedAt;
}

