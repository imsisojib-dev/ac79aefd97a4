import 'package:http/http.dart' as http;
abstract class IApiInterceptor{
  Future<http.Response> get({required String url, Map<String,String>? headers,Map<String,dynamic>? body,});
  Future<http.Response> post({required String url, Map<String,String>? headers,dynamic body,});
  Future<http.Response> delete({required String url, Map<String,String>? headers,dynamic body,});
  Future<http.Response> put({required String url, Map<String,String>? headers,dynamic body,});
  Future<http.Response> postFormData({required String url, required Map<String,String> headers, required Map<String,String> map, List<http.MultipartFile>? files, String method = "POST"});
}