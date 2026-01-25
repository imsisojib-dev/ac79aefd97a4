package com.imsisojib.device_monitor.src.core.base.auth;

import com.imsisojib.device_monitor.src.core.base.dtos.LoggedInUserDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service("authService")
@RequiredArgsConstructor
public class AuthenticationService {

    public boolean isApiKeyAuthenticated() {
        return AuthenticationContextHolder.isApiKeyAuthenticated();
    }

    public boolean isTokenAuthenticated() {
        return AuthenticationContextHolder.isTokenAuthenticated();
    }

    public boolean isInternalService() {
        ApiKeyAuthentication auth = AuthenticationContextHolder.getApiKeyAuthentication();
        return auth != null && auth.isAuthenticated();
    }

    public boolean isSpecificService(String serviceName) {
        ApiKeyAuthentication auth = AuthenticationContextHolder.getApiKeyAuthentication();
        return auth != null &&
                auth.isAuthenticated() &&
                serviceName.equals(auth.getServiceName());
    }

    public boolean hasAnyAuthentication() {
        return isApiKeyAuthenticated() || isTokenAuthenticated();
    }


    public String getCurrentServiceName() {
        ApiKeyAuthentication auth = AuthenticationContextHolder.getApiKeyAuthentication();
        return auth != null ? auth.getServiceName() : null;
    }
}