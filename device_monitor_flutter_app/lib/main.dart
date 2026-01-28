import 'package:device_monitor/src/config/env.dart';
import 'package:flutter/material.dart';
import 'package:device_monitor/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Env.baseUrl = 'http://172.236.151.18:8089/device_monitor';
  Env.type = EEnvType.prod;
  //To access api
  Env.X_API_KEY = 'DEVICEMONITOR3D4E5F6G7H8I9J0K1L2M3N4O5P6';
  Env.X_SERVICE_NAME = 'device-monitor';

  await initApp();
}
