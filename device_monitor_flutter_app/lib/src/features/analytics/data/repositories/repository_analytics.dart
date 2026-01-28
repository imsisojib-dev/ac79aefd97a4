import 'dart:convert';

import 'package:device_monitor/src/config/config_api.dart';
import 'package:device_monitor/src/config/env.dart';
import 'package:device_monitor/src/core/data/models/api_response.dart';
import 'package:device_monitor/src/core/domain/interfaces/interface_api_interceptor.dart';
import 'package:device_monitor/src/core/services/token_service.dart';
import 'package:device_monitor/src/features/analytics/data/models/analytics_data.dart';
import 'package:device_monitor/src/features/analytics/data/requests/request_analytics.dart';
import 'package:device_monitor/src/features/analytics/domain/interfaces/i_repository_analytics.dart';
import 'package:http/http.dart' as http;

class RepositoryAnalytics implements IRepositoryAnalytics {
  final IApiInterceptor apiInterceptor;
  final TokenService tokenService;

  RepositoryAnalytics({
    required this.apiInterceptor,
    required this.tokenService,
  });

  @override
  Future<ApiResponse<AnalyticsData>> loadAnalytics(RequestAnalytics request) async {
    String url = "${Env.baseUrl}${ConfigApi.analysis}/${request.deviceId}?startDate=${request.startDate}&endDate=${request.endDate}";

    http.Response response = await apiInterceptor.get(
      url: url,
      headers: tokenService.getHeadersForJson(),
    );

    var json = jsonDecode(response.body);
    return ApiResponse.fromJson(
      json,
      (data) => AnalyticsData.fromJson(data),
    );
  }
}
