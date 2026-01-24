package com.device_monitor

import android.app.ActivityManager
import android.content.Context
import android.os.BatteryManager
import android.os.Build
import android.os.PowerManager
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.device_monitor/vitals"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getThermalStatus" -> {
                    try {
                        val thermalStatus = getThermalStatus()
                        result.success(thermalStatus)
                    } catch (e: Exception) {
                        result.error("THERMAL_ERROR", "Failed to get thermal status: ${e.message}", null)
                    }
                }
                "getBatteryLevel" -> {
                    try {
                        val batteryLevel = getBatteryLevel()
                        result.success(batteryLevel)
                    } catch (e: Exception) {
                        result.error("BATTERY_ERROR", "Failed to get battery level: ${e.message}", null)
                    }
                }
                "getMemoryUsage" -> {
                    try {
                        val memoryUsage = getMemoryUsage()
                        result.success(memoryUsage)
                    } catch (e: Exception) {
                        result.error("MEMORY_ERROR", "Failed to get memory usage: ${e.message}", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    /**
     * Get thermal status of the device
     * Returns: 0 (None), 1 (Light), 2 (Moderate), 3 (Severe)
     */
    private fun getThermalStatus(): Int {
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager

        return when {
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q -> {
                // API 29+ - Use getCurrentThermalStatus
                getThermalStatusModern(powerManager)
            }
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.N -> {
                // API 24-28 - Use getThermalHeadroom, not official but accpeted by OEMs
                getThermalStatusLegacy(powerManager)
            }
            else -> {
                // API < 24 - No thermal API available
                0 // Default to None
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    private fun getThermalStatusModern(powerManager: PowerManager): Int {
        val thermalStatus = powerManager.currentThermalStatus

        // Map thermal status to 0-3 range
        return when (thermalStatus) {
            PowerManager.THERMAL_STATUS_NONE -> 0
            PowerManager.THERMAL_STATUS_LIGHT -> 1
            PowerManager.THERMAL_STATUS_MODERATE -> 2
            PowerManager.THERMAL_STATUS_SEVERE,
            PowerManager.THERMAL_STATUS_CRITICAL,
            PowerManager.THERMAL_STATUS_EMERGENCY,
            PowerManager.THERMAL_STATUS_SHUTDOWN -> 3
            else -> 0
        }
    }

    @RequiresApi(Build.VERSION_CODES.N)
    private fun getThermalStatusLegacy(powerManager: PowerManager): Int {
        return try {
            val headroom = powerManager.getThermalHeadroom(0)

            // Map headroom (0.0-1.0+) to thermal status (0-3)
            // Higher headroom = cooler device
            when {
                headroom >= 1.0f -> 0  // None - plenty of headroom
                headroom >= 0.5f -> 1  // Light - moderate headroom
                headroom >= 0.2f -> 2  // Moderate - low headroom
                else -> 3              // Severe - very low headroom
            }
        } catch (e: Exception) {
            // getThermalHeadroom not available or failed
            0 // Default to None
        }
    }

    /**
     * Get battery level percentage
     * Returns: 0-100
     */
    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager

        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                // API 21+ - Use BatteryManager
                val level = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)

                // Ensure value is in valid range
                level.coerceIn(0, 100)
            } else {
                // Fallback for older devices
                0
            }
        } catch (e: Exception) {
            // If battery info unavailable, return 0
            0
        }
    }

    /**
     * Get memory usage percentage
     * Returns: 0-100
     */
    private fun getMemoryUsage(): Int {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)

        return try {
            // Calculate used memory percentage
            val totalMemory = memoryInfo.totalMem
            val availableMemory = memoryInfo.availMem
            val usedMemory = totalMemory - availableMemory

            // Calculate percentage
            val percentage = ((usedMemory.toDouble() / totalMemory.toDouble()) * 100).toInt()

            // Ensure value is in valid range
            percentage.coerceIn(0, 100)
        } catch (e: Exception) {
            // If memory info unavailable, return 0
            0
        }
    }
}
