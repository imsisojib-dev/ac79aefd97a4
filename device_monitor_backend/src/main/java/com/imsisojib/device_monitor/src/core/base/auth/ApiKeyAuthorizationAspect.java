package com.imsisojib.device_monitor.src.core.base.auth;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;

@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
public class ApiKeyAuthorizationAspect {
    
    private final AuthenticationService authService;
    
    @Around("@annotation(requireApiKey)")
    public Object checkApiKeyAuthorization(ProceedingJoinPoint joinPoint, RequireApiKey requireApiKey) 
            throws Throwable {
        
        // Check if API key authentication is present
        if (!authService.isApiKeyAuthenticated()) {
            log.error("API key authentication required but not provided");
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "API key authentication required");
        }
        
        // Check specific service if specified
        String requiredService = requireApiKey.service();
        if (!requiredService.isEmpty() && !authService.isSpecificService(requiredService)) {
            log.error("Service '{}' required but authenticated as different service", requiredService);
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Access denied for this service");
        }
        
        return joinPoint.proceed();
    }
}