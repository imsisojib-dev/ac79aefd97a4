package com.imsisojib.device_monitor.src.core.base.config;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

@Converter
public class StringSetToStringConverter implements AttributeConverter<Set<String>, String> {

    @Override
    public String convertToDatabaseColumn(Set<String> attribute) {
        return attribute == null ? null : attribute.stream()
                .sorted()
                .map(String::valueOf)
                .collect(Collectors.joining("||"));
    }

    @Override
    public Set<String> convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isEmpty()) return new HashSet<>();
        return Arrays.stream(dbData.split("||"))
                .map(String::valueOf)
                .collect(Collectors.toSet());
    }
}
