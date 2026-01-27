import 'package:device_monitor/src/core/data/models/meta.dart';

typedef JsonParser<T> = T Function(dynamic json);

class ApiResponse<T> {
  int? statusCode;
  T? data;
  String? status;
  String? message;
  Meta? meta;

  ApiResponse({
    this.statusCode,
    this.data,
    this.status,
    this.message,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    JsonParser<T> parser,
  ) {
    return ApiResponse<T>(
      statusCode: json['statusCode'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? parser(json['data']) : null,
      meta: Meta.fromJson(json['meta']),
    );
  }
}
