import 'package:device_monitor/src/core/data/models/api_response.dart';
import 'package:device_monitor/src/features/vitals/data/requests/request_vitals.dart';

abstract class IRepositoryVitals{
  Future<ApiResponse> getVitals(RequestVitals request);
}