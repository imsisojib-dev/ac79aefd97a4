package com.imsisojib.device_monitor.src.core.base.config;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Converter
public class StringListToStringConverter implements AttributeConverter<List<String>, String> {

    @Override
    public String convertToDatabaseColumn(List<String> attribute) {
        return attribute == null ? null : attribute.stream()
                .sorted()
                .map(String::valueOf)
                .collect(Collectors.joining("||"));
    }

    @Override
    public List<String> convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isEmpty()) return new ArrayList<>();
        return Arrays.stream(dbData.split("||"))
                .map(String::valueOf)
                .collect(Collectors.toList());
    }
}
