import 'dart:convert';
import 'package:device_monitor/src/core/domain/interfaces/interface_api_interceptor.dart';
import 'package:device_monitor/src/core/utils/helpers/connectivity_helper.dart';
import 'package:device_monitor/src/core/utils/helpers/debugger_helper.dart';
import 'package:http/http.dart' as http;

class ApiInterceptor implements IApiInterceptor {
  final Map<String, dynamic> _serverTimeoutResponse = {"statusCode": 408, "message": "Server is not responding. Please try again later."};
  final Map<String, dynamic> _noInternetResponse = {"statusCode": 503, "message": "No Internet Connection! Please check your internet connection."};

  ApiInterceptor();

  @override
  Future<http.Response> get({
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Duration timeoutDuration = const Duration(seconds: 120),
  }) async {
    Debugger.apiRequest(
      url: url,
      body: body,
    );
    if (!await ConnectivityHelper.hasInternetConnection()) {
      return http.Response(jsonEncode(_noInternetResponse), 503);
    }
    try {
      Uri uri = Uri.parse(url);
      var response = await http.get(uri, headers: headers).timeout(
        timeoutDuration,
        onTimeout: () async {
          return http.Response(jsonEncode(_serverTimeoutResponse), 408);
        },
      );

      Debugger.apiResponse(
        url: url,
        body: response.body,
        statusCode: response.statusCode
      );

      return response;
    } catch (e) {
      Debugger.error(title: 'ApiInterceptor.get()', data: e);
      return http.Response('$e', 500);
    }
  }

  @override
  Future<http.Response> post({
    required String url,
    Map<String, String>? headers,
    dynamic body,
    Duration timeoutDuration = const Duration(seconds: 120),
  }) async {
    Debugger.apiRequest(
      url: url,
      body: body,
    );
    if (!await ConnectivityHelper.hasInternetConnection()) {
      return http.Response(jsonEncode(_noInternetResponse), 503);
    }
    try {
      Uri uri = Uri.parse(url);
      var response = await http.post(uri, body: body, headers: headers).timeout(
        timeoutDuration,
        onTimeout: () async {
          return http.Response(jsonEncode(_serverTimeoutResponse), 408);
        },
      );
      Debugger.apiResponse(
        url: url,
        body: response.body,
        statusCode: response.statusCode,
      );
      return response;
    } catch (e) {
      Debugger.error(title: 'ApiInterceptor.post()', data: e);
      return http.Response('$e', 500);
    }
  }

  @override
  Future<http.Response> delete({
    required String url,
    Map<String, String>? headers,
    dynamic body,
    Duration timeoutDuration = const Duration(seconds: 120),
  }) async {
    Debugger.apiRequest(
      url: url,
      body: body,
    );
    if (!await ConnectivityHelper.hasInternetConnection()) {
      return http.Response(jsonEncode(_noInternetResponse), 503);
    }
    try {
      Uri uri = Uri.parse(url);
      var response = await http.delete(uri, body: body, headers: headers).timeout(
        timeoutDuration,
        onTimeout: () async {
          return http.Response(jsonEncode(_serverTimeoutResponse), 408);
        },
      );
      Debugger.apiResponse(
        url: url,
        body: response.body,
        statusCode: response.statusCode,
      );

      return response;
    } catch (e) {
      Debugger.error(title: 'ApiInterceptor.post()', data: e);
      return http.Response('$e', 500);
    }
  }

  @override
  Future<http.Response> put({
    required String url,
    Map<String, String>? headers,
    body,
    Duration timeoutDuration = const Duration(seconds: 120),
  }) async {
    Debugger.apiRequest(
      url: url,
      body: body,
    );
    if (!await ConnectivityHelper.hasInternetConnection()) {
      return http.Response(jsonEncode(_noInternetResponse), 503);
    }
    try {
      Uri uri = Uri.parse(url);
      var response = await http.put(uri, body: body, headers: headers).timeout(
        timeoutDuration,
        onTimeout: () async {
          return http.Response(jsonEncode(_serverTimeoutResponse), 408);
        },
      );
      Debugger.apiResponse(
        url: url,
        body: response.body,
        statusCode: response.statusCode,
      );
      return response;
    } catch (e) {
      Debugger.error(title: 'ApiInterceptor.post()', data: e);
      return http.Response('$e', 500);
    }
  }

  @override
  Future<http.Response> postFormData({
    required String url,
    required Map<String, String> headers,
    required Map<String, String> map,
    List<http.MultipartFile>? files,
    String method = "POST",
  }) async {
    Debugger.apiRequest(
      url: url,
      body: map,
    );
    if (!await ConnectivityHelper.hasInternetConnection()) {
      return http.Response(jsonEncode(_noInternetResponse), 503);
    }

    try {
      Uri uri = Uri.parse(url);
      var requestHttp = http.MultipartRequest(method, uri);
      requestHttp.fields.addAll(map);
      requestHttp.headers.addAll(headers);

      //add files if available
      if (files != null) {
        requestHttp.files.addAll(files);
      }

      http.StreamedResponse streamResponse = await requestHttp.send();
      http.Response response = await http.Response.fromStream(streamResponse);
      Debugger.apiResponse(
        url: url,
        body: response.body,
        statusCode: response.statusCode,
      );
      return response;
    } catch (e) {
      Debugger.error(title: 'ApiInterceptor.postFormData()', data: e);
      return http.Response('$e', 404);
    }
  }
}
