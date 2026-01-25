package com.imsisojib.device_monitor.src.core.base.util;


public class EnvConfig {

    public static String getString(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value != null) {
            return value;
        }

        return defaultValue;
    }

    public static long getLong(String key, long defaultValue) {
        try {
            String value = System.getenv(key);
            if (value != null) {
                return Long.parseLong(value);
            }
        } catch (Exception e) {}
        return defaultValue;
    }

    public static int getInt(String key, int defaultValue) {
        try {
            String value = System.getenv(key);
            if (value != null) {
                return Integer.parseInt(value);
            }
        } catch (Exception e) {}
        return defaultValue;
    }

    public static boolean getBoolean(String key, boolean defaultValue) {
        try {
            String value = System.getenv(key);
            if (value != null) {
                return Boolean.parseBoolean(value);
            }
        } catch (Exception e) {}
        return defaultValue;
    }

}
