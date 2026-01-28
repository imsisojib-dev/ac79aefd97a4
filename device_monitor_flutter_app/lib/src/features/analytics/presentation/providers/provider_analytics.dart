import 'package:device_monitor/src/core/di/di_container.dart';
import 'package:device_monitor/src/core/enums/e_loading.dart';
import 'package:device_monitor/src/core/utils/helpers/format_helper.dart';
import 'package:device_monitor/src/features/analytics/data/enums/e_date_range.dart';
import 'package:device_monitor/src/features/analytics/data/models/analytics_data.dart';
import 'package:device_monitor/src/features/analytics/data/requests/request_analytics.dart';
import 'package:device_monitor/src/features/analytics/domain/usecases/usecase_fetch_analytics.dart';
import 'package:flutter/foundation.dart';

class ProviderAnalytics extends ChangeNotifier {
  AnalyticsData? _analyticsData;
  late String _deviceId;
  ELoading? _loading;
  String? _error;
  EDateRange _selectedRange = EDateRange.oneDay;

  AnalyticsData? get analyticsData => _analyticsData;

  ELoading? get loading => _loading;

  String? get error => _error;

  EDateRange get selectedRange => _selectedRange;

  //setters
  set loading(ELoading? state) {
    _loading = state;
    notifyListeners();
  }

  void selectDateRange(EDateRange range) {
    if (_selectedRange != range) {
      _selectedRange = range;
      loadAnalytics(_deviceId);
    }
  }

  Future<void> loadAnalytics(String deviceId) async {
    _deviceId = deviceId;
    loading = ELoading.loading;
    try {
      RequestAnalytics request = RequestAnalytics(
        deviceId: deviceId,
        startDate: FormatHelper.formatDateTimeToString(DateTime.now().subtract(Duration(days: _selectedRange.days))),
        endDate: FormatHelper.formatDateTimeToString(DateTime.now()),
      );
      var result = await UseCaseFetchAnalytics(repositoryAnalytics: sl()).execute(request);
      result.fold(
        (error) {
          _error = error.message;
        },
        (response) {
          _error = null;
          _analyticsData = response.data;
        },
      );
    } catch (e) {
      _error = 'Failed to load analytics: ${e.toString()}';
    }

    //wait a bit before loading
    await Future.delayed(Duration(seconds: 1));
    loading = null;
  }

  Future<void> refresh(String deviceId) async {
    await Future.wait([
      loadAnalytics(deviceId),
    ]);
  }
}
