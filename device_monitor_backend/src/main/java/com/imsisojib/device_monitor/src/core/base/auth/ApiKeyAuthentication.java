package com.imsisojib.device_monitor.src.core.base.auth;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ApiKeyAuthentication {
    private String apiKey;
    private String serviceName;
    private boolean authenticated;
}