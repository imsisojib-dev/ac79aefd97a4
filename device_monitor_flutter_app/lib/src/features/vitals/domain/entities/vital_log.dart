class VitalLog {
  final String? id;
  final String deviceId;
  final DateTime timestamp;
  final int thermalValue;
  final int batteryLevel;
  final int memoryUsage;

  VitalLog({
    this.id,
    required this.deviceId,
    required this.timestamp,
    required this.thermalValue,
    required this.batteryLevel,
    required this.memoryUsage,
  });

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'timestamp': timestamp.toIso8601String(),
      'thermal_value': thermalValue,
      'battery_level': batteryLevel,
      'memory_usage': memoryUsage,
    };
  }

  factory VitalLog.fromJson(Map<String, dynamic> json) {
    return VitalLog(
      id: json['id']?.toString(),
      deviceId: json['device_id'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      thermalValue: json['thermal_value'] ?? 0,
      batteryLevel: json['battery_level'] ?? 0,
      memoryUsage: json['memory_usage'] ?? 0,
    );
  }
}
