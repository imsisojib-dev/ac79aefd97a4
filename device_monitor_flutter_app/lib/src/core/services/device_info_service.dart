import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class DeviceInfoService {
  String? osName;
  String? osVersion;
  String? deviceBrand;
  String? deviceModel;
  String? device;
  String? androidId;
  String? identifierForVendor;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      osName = "Android";
      osVersion = androidInfo.version.release;
      deviceBrand = androidInfo.brand;
      deviceModel = androidInfo.model;
      androidId = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      osName = "iOS";
      osVersion = iosInfo.systemVersion;
      deviceBrand = "Apple";
      deviceModel = iosInfo.utsname.machine;
      identifierForVendor = iosInfo.identifierForVendor;
    } else {
      osName = osVersion = deviceBrand = deviceModel = "unknown";
    }

    device = "$deviceBrand $deviceModel";
    _initialized = true;
  }
}
