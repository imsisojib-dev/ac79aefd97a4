package com.imsisojib.device_monitor.src.core.base.config;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

@Converter
public class LongSetToStringConverter implements AttributeConverter<Set<Long>, String> {

    @Override
    public String convertToDatabaseColumn(Set<Long> attribute) {
        return attribute == null ? null : attribute.stream()
                .sorted()
                .map(String::valueOf)
                .collect(Collectors.joining(","));
    }

    @Override
    public Set<Long> convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isEmpty()) return new HashSet<>();
        return Arrays.stream(dbData.split(","))
                .map(Long::valueOf)
                .collect(Collectors.toSet());
    }
}
