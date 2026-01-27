import 'package:device_monitor/src/core/di/di_container.dart';
import 'package:device_monitor/src/core/services/device_vitals_service.dart';
import 'package:device_monitor/src/features/vitals/domain/entities/vitals_entity.dart';
import 'package:flutter/foundation.dart';

class ProviderHome extends ChangeNotifier {

  VitalsEntity? _currentVitals;
  bool _isLoading = false;
  bool _isLogging = false;
  String? _error;
  String? _successMessage;

  VitalsEntity? get currentVitals => _currentVitals;
  bool get isLoading => _isLoading;
  bool get isLogging => _isLogging;
  String? get error => _error;
  String? get successMessage => _successMessage;

  Future<void> refreshVitals() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentVitals = await sl<DeviceVitalsService>().getAllVitals();
      _error = null;
    } catch (e) {
      _error = 'Failed to read sensors: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}
