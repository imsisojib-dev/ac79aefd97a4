
import 'package:device_monitor/src/core/domain/interfaces/interface_api_interceptor.dart';
import 'package:device_monitor/src/core/services/api_interceptor.dart';
import 'package:device_monitor/src/core/services/token_service.dart';
import 'package:device_monitor/src/features/vitals/data/repopsitories/repository_vitals.dart';
import 'package:device_monitor/src/features/vitals/domain/interfaces/i_repository_vitals.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final testSl = GetIt.instance;

/// Initialize dependencies for Vitals integration tests
Future<void> initVitalsTestDependencies() async {

  ///SERVICES
  testSl.registerLazySingleton<IApiInterceptor>(() => ApiInterceptor());
  testSl.registerSingleton(TokenService());

  // Logger
  testSl.registerLazySingleton(
        () => Logger(printer: PrettyPrinter(colors: false)),
  );


  ///REPOSITORIES
  testSl.registerLazySingleton<IRepositoryVitals>(
        () => RepositoryVitals(
      apiInterceptor: testSl(),
      tokenService: testSl(),
    ),
  );
}

/// Clean up all test dependencies
Future<void> cleanupTestDependencies() async {
  await testSl.reset();
}