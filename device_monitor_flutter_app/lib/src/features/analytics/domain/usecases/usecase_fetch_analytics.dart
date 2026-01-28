import 'package:dartz/dartz.dart';
import 'package:device_monitor/src/core/data/models/api_response.dart';
import 'package:device_monitor/src/core/data/models/failure.dart';
import 'package:device_monitor/src/core/domain/interfaces/interface_use_case.dart';
import 'package:device_monitor/src/features/analytics/data/models/analytics_data.dart';
import 'package:device_monitor/src/features/analytics/data/requests/request_analytics.dart';
import 'package:device_monitor/src/features/analytics/domain/interfaces/i_repository_analytics.dart';

class UseCaseFetchAnalytics implements IUseCase<RequestAnalytics, ApiResponse<AnalyticsData>> {
  final IRepositoryAnalytics repositoryAnalytics;

  UseCaseFetchAnalytics({required this.repositoryAnalytics});

  @override
  Future<Either<Failure, ApiResponse<AnalyticsData>>> execute(RequestAnalytics request) async {
    var response = await repositoryAnalytics.loadAnalytics(request);

    if(response.statusCode==200) {
      return Right(response);
    }

    return Left(Failure(
      message: response.message??"Something is went wrong!",
      statusCode: response.statusCode??500,
    ));
  }
}
