import 'package:device_monitor/src/features/vitals/domain/entities/analytics_data.dart';
import 'package:device_monitor/src/features/vitals/domain/entities/vital_log.dart';
import 'package:flutter/foundation.dart';

class ProviderAnalytics extends ChangeNotifier {

  AnalyticsData? _analytics;
  bool _isLoading = false;
  String? _error;

  AnalyticsData? get analytics => _analytics;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAnalytics() async {
    try {
      _analytics = null;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load analytics: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await Future.wait([
      loadAnalytics(),
    ]);
  }
}