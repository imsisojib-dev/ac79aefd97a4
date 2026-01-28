import 'package:device_monitor/src/core/data/models/api_response.dart';
import 'package:device_monitor/src/features/analytics/data/models/analytics_data.dart';
import 'package:device_monitor/src/features/analytics/data/requests/request_analytics.dart';

abstract class IRepositoryAnalytics {
  Future<ApiResponse<AnalyticsData>> loadAnalytics(RequestAnalytics request);
}