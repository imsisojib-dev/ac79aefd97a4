package com.imsisojib.device_monitor.src.config;

import com.imsisojib.device_monitor.src.core.base.auth.ApiKeyAuthentication;
import com.imsisojib.device_monitor.src.core.base.auth.AuthenticationContextHolder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Slf4j
@Component
public class TokenExtractFilter extends OncePerRequestFilter {

    @Value("${api.security.enabled:true}")
    private boolean apiKeyEnabled;

    @Value("${api.security.key:#{null}}")
    private String singleApiKey;

    // Map of API keys to service names
    @Value("#{${api.security.keys:{'default':'default'}}}")
    private Map<String, String> apiKeys;

    private static final String API_KEY_HEADER = "X-API-Key";
    private static final String SERVICE_NAME_HEADER = "X-Service-Name";


    List<String> permittedUrlPatterns = Arrays.asList(
            "/swagger-ui/**",
            "/v3/**",
            "/**/public/**",
            "/webxmonitoringpoint/**"
    );

    // URLs that require API key authentication instead of token
    List<String> apiKeyUrlPatterns = Arrays.asList(
            "/api/vitals/**",
            "/api/devices/**",
            "/api/analysis/**"
    );

    @Override
    public void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        // CORS headers
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "*");

        // Handle preflight request
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            response.setStatus(HttpServletResponse.SC_NO_CONTENT);
            return;
        }

        // Clear any previous authentication
        AuthenticationContextHolder.clear();

        String path = request.getRequestURI().substring(request.getContextPath().length());
        log.info("### REQ_URI -> " + path);

        boolean isPermittedURI = permittedUrlPatterns.stream()
                .anyMatch(p -> new AntPathMatcher().match(p, path));

        boolean isApiKeyURI = apiKeyEnabled && apiKeyUrlPatterns.stream()
                .anyMatch(p -> new AntPathMatcher().match(p, path));

        // Try API key authentication first if enabled and URI matches
        if(isApiKeyURI){
            if (authenticateWithApiKey(request, response)) {
                chain.doFilter(request, response);
            } else {
                // API key required but not valid
                sendUnauthorizedResponse(response, "Invalid or missing API key");
            }
        }else{
            chain.doFilter(request, response);
        }

    }

    private boolean authenticateWithApiKey(HttpServletRequest request, HttpServletResponse response) {
        String requestApiKey = request.getHeader(API_KEY_HEADER);
        String serviceName = request.getHeader(SERVICE_NAME_HEADER);

        if (requestApiKey == null) {
            log.debug("No API key provided in request");
            return false;
        }

        // Check multiple API keys
        if (apiKeys != null && apiKeys.containsKey(requestApiKey)) {
            String expectedServiceName = apiKeys.get(requestApiKey);

            // Validate service name if provided
            if (serviceName != null && !expectedServiceName.equals(serviceName)) {
                log.warn("Service name mismatch. Expected: {}, Received: {}",
                        expectedServiceName, serviceName);
                return false;
            }

            ApiKeyAuthentication auth = new ApiKeyAuthentication(requestApiKey, expectedServiceName, true);
            AuthenticationContextHolder.setApiKeyAuthentication(auth);
            log.info("Authenticated service: {}", expectedServiceName);
            return true;
        }

        log.warn("Invalid API key provided");
        return false;
    }

    private void sendUnauthorizedResponse(HttpServletResponse response, String message)
            throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.getWriter().write(String.format(
                "{\"status\": 401, \"body\": null, \"message\": \"%s\"}", message));
    }
}