import 'package:device_monitor/src/core/enums/e_loading.dart';
import 'package:device_monitor/src/features/device/domain/entities/device_entity.dart';
import 'package:flutter/cupertino.dart';

class ProviderDeviceMonitor extends ChangeNotifier{
  //states
  ELoading _loading = ELoading.none;
  DeviceEntity? _currentDevice;

  //getters
  ELoading get loading => _loading;
  DeviceEntity? get currentDevice => _currentDevice;


  //setters
  set loading(ELoading state){
    _loading = state;
    notifyListeners();
  }

  //methods
  void registerDevice(){

  }
}