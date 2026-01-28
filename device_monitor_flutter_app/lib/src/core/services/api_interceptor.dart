import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:device_monitor/src/core/domain/interfaces/interface_api_interceptor.dart';
import 'package:device_monitor/src/core/utils/helpers/connectivity_helper.dart';
import 'package:device_monitor/src/core/utils/helpers/debugger_helper.dart';
import 'package:http/http.dart' as http;

class ApiInterceptor implements IApiInterceptor {
  final Map<String, dynamic> _serverTimeoutResponse = {"statusCode": 408, "message": "Server is not responding. Please try again later."};
  final Map<String, dynamic> _noInternetResponse = {"statusCode": 503, "message": "No Internet Connection! Please check your internet connection."};
  final Map<String, dynamic> _serverConnectionError = {"statusCode": 503, "message": "Couldn't connect with server. Server may be down or please check your internet connection."};
  final Map<String, dynamic> _badResponseException = {"statusCode": 500, "message": "Bad response from server."};
  final Map<String, dynamic> _unexpectedException = {"statusCode": 404, "message": "Unexpected error! Something is went wrong."};

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
    }
    on TimeoutException catch (_) {
      return http.Response(jsonEncode(_serverTimeoutResponse), 500);
    }
    on SocketException catch (_) {
      return http.Response(jsonEncode(_serverConnectionError), 503);
    }
    on HttpException catch (_) {
      return http.Response(jsonEncode(_badResponseException), 500);
    }
    catch (e) {
      Debugger.error(title: 'ApiInterceptor.get()', data: e,);
      return http.Response(jsonEncode(_unexpectedException), 404);
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
    } on TimeoutException catch (_) {
      return http.Response(jsonEncode(_serverTimeoutResponse), 500);
    }
    on SocketException catch (_) {
      return http.Response(jsonEncode(_serverConnectionError), 503);
    }
    on HttpException catch (_) {
      return http.Response(jsonEncode(_badResponseException), 500);
    }
    catch (e) {
      Debugger.error(title: 'ApiInterceptor.get()', data: e,);
      return http.Response(jsonEncode(_unexpectedException), 404);
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
    }
    on TimeoutException catch (_) {
      return http.Response(jsonEncode(_serverTimeoutResponse), 500);
    }
    on SocketException catch (_) {
      return http.Response(jsonEncode(_serverConnectionError), 503);
    }
    on HttpException catch (_) {
      return http.Response(jsonEncode(_badResponseException), 500);
    }
    catch (e) {
      Debugger.error(title: 'ApiInterceptor.get()', data: e,);
      return http.Response(jsonEncode(_unexpectedException), 404);
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
    }
    on TimeoutException catch (_) {
      return http.Response(jsonEncode(_serverTimeoutResponse), 500);
    }
    on SocketException catch (_) {
      return http.Response(jsonEncode(_serverConnectionError), 503);
    }
    on HttpException catch (_) {
      return http.Response(jsonEncode(_badResponseException), 500);
    }
    catch (e) {
      Debugger.error(title: 'ApiInterceptor.get()', data: e,);
      return http.Response(jsonEncode(_unexpectedException), 404);
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
    }
    on TimeoutException catch (_) {
      return http.Response(jsonEncode(_serverTimeoutResponse), 500);
    }
    on SocketException catch (_) {
      return http.Response(jsonEncode(_serverConnectionError), 503);
    }
    on HttpException catch (_) {
      return http.Response(jsonEncode(_badResponseException), 500);
    }
    catch (e) {
      Debugger.error(title: 'ApiInterceptor.get()', data: e,);
      return http.Response(jsonEncode(_unexpectedException), 404);
    }
  }
}
