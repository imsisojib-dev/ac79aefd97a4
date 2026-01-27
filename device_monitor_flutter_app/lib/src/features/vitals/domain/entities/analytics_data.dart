class AnalyticsData {
  final double avgThermal;
  final double avgBattery;
  final double avgMemory;
  final int totalEntries;
  final double minBattery;
  final double maxBattery;
  final double minMemory;
  final double maxMemory;

  AnalyticsData({
    required this.avgThermal,
    required this.avgBattery,
    required this.avgMemory,
    required this.totalEntries,
    required this.minBattery,
    required this.maxBattery,
    required this.minMemory,
    required this.maxMemory,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      avgThermal: (json['avg_thermal'] ?? 0).toDouble(),
      avgBattery: (json['avg_battery'] ?? 0).toDouble(),
      avgMemory: (json['avg_memory'] ?? 0).toDouble(),
      totalEntries: json['total_entries'] ?? 0,
      minBattery: (json['min_battery'] ?? 0).toDouble(),
      maxBattery: (json['max_battery'] ?? 0).toDouble(),
      minMemory: (json['min_memory'] ?? 0).toDouble(),
      maxMemory: (json['max_memory'] ?? 0).toDouble(),
    );
  }
}