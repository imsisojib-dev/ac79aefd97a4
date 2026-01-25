package com.imsisojib.device_monitor.src.core.base.auth;

public class AuthenticationContextHolder {
    
    private static final ThreadLocal<ApiKeyAuthentication> apiKeyContext = new ThreadLocal<>();
    private static final ThreadLocal<String> authTokenContext = new ThreadLocal<>();
    
    public static void setApiKeyAuthentication(ApiKeyAuthentication auth) {
        apiKeyContext.set(auth);
    }
    
    public static ApiKeyAuthentication getApiKeyAuthentication() {
        return apiKeyContext.get();
    }
    
    public static void setAuthToken(String token) {
        authTokenContext.set(token);
    }
    
    public static String getAuthToken() {
        return authTokenContext.get();
    }
    
    public static boolean isApiKeyAuthenticated() {
        ApiKeyAuthentication auth = apiKeyContext.get();
        return auth != null && auth.isAuthenticated();
    }
    
    public static boolean isTokenAuthenticated() {
        return authTokenContext.get() != null;
    }
    
    public static void clear() {
        apiKeyContext.remove();
        authTokenContext.remove();
    }
}