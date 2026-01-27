import 'dart:convert';
import 'dart:io';

import 'package:device_monitor/src/config/env.dart';

class TokenService{
  String _token = "";
  TokenService();

  String token(){
    return _token;
  }

  void updateToken(String token){
    _token = token;
  }

  Map<String,String> getHeadersForJson(){
    return {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.connectionHeader : "keep-alive",
      'X-API-Key' : Env.X_API_KEY,
      'X-Service-Name' : Env.X_SERVICE_NAME,
      //HttpHeaders.authorizationHeader : "Bearer $_token",
    };
  }

  Map<String,String> getUnAuthHeadersForJson(){
    return {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.connectionHeader : "keep-alive",
    };
  }

  Map<String,String> getHeadersForFormData(){
    return {
      HttpHeaders.contentTypeHeader: "multipart/form-data",
      HttpHeaders.connectionHeader : "keep-alive",
      HttpHeaders.authorizationHeader : "Bearer $_token",
    };
  }

  String base64Convert(String str){
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode(str);
  }

}