typedef JsonParser<T> = T Function(dynamic json);

class ApiResponse<T> {
  int? statusCode;
  T? data;
  String? status;
  String? message;

  ApiResponse({
    this.statusCode,
    this.data,
    this.status,
    this.message,
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
    );
  }
}
