package com.imsisojib.device_monitor.src.core.base.constants;

import lombok.Getter;
import lombok.ToString;


@Getter
@ToString
public enum SortOrder {
    ASC("asc"),
    DESC("desc");

    private final String value;

    SortOrder(String value) {
        this.value = value;
    }
}
