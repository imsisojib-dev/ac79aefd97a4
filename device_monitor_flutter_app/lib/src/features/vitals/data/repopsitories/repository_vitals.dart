import 'dart:convert';

import 'package:device_monitor/src/config/config_api.dart';
import 'package:device_monitor/src/config/env.dart';
import 'package:device_monitor/src/core/data/models/api_response.dart';
import 'package:device_monitor/src/core/domain/interfaces/interface_api_interceptor.dart';
import 'package:device_monitor/src/core/services/token_service.dart';
import 'package:device_monitor/src/features/vitals/data/requests/request_vitals.dart';
import 'package:device_monitor/src/features/vitals/domain/entities/vitals_entity.dart';
import 'package:device_monitor/src/features/vitals/domain/interfaces/i_repository_vitals.dart';
import 'package:http/http.dart' as http;

class RepositoryVitals implements IRepositoryVitals {
  final IApiInterceptor apiInterceptor;
  final TokenService tokenService;

  RepositoryVitals({
    required this.apiInterceptor,
    required this.tokenService,
  });

  @override
  Future<ApiResponse> getVitals(RequestVitals request) async {
    String url = "${Env.baseUrl}${ConfigApi.vitals}";

    http.Response response = await apiInterceptor.post(
      url: url,
      headers: tokenService.getHeadersForJson(),
    );

    var json = jsonDecode(response.body);
    return ApiResponse.fromJson(
      json,
      (data) => data,
    );
  }

  @override
  Future<ApiResponse<VitalsEntity>> saveVitals(RequestVitals request) async {
    String url = "${Env.baseUrl}${ConfigApi.vitals}";

    http.Response response = await apiInterceptor.post(
      url: url,
      body: jsonEncode(request.toJsonForCreate()),
      headers: tokenService.getHeadersForJson(),
    );

    var json = jsonDecode(response.body);
    return ApiResponse.fromJson(
      json,
      (data) => VitalsEntity.fromJson(data),
    );
  }
}
