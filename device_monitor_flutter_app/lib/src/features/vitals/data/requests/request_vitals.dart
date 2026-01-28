import 'package:device_monitor/src/core/utils/helpers/format_helper.dart';

class RequestVitals {
  String deviceId;
  int? thermalStatus;
  int? batteryLevel;
  int? memoryUsage;
  DateTime timestamp = DateTime.now();

  RequestVitals({
    required this.deviceId,
    this.thermalStatus,
    this.batteryLevel,
    this.memoryUsage,
  });

  Map<String, dynamic> toJsonForCreate() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['thermalStatus'] = thermalStatus;
    data['batteryLevel'] = batteryLevel;
    data['memoryUsage'] = memoryUsage;
    data['timestamp'] = FormatHelper.formatDateTimeForServer(timestamp);
    data['deviceId'] = deviceId;
    return data;
  }

}
