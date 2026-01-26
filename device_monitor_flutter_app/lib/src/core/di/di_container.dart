import 'package:device_monitor/src/config/env.dart';
import 'package:device_monitor/src/core/data/repositories/cache_repository_impl.dart';
import 'package:device_monitor/src/core/domain/interfaces/interface_api_interceptor.dart';
import 'package:device_monitor/src/core/domain/interfaces/interface_cache_repository.dart';
import 'package:device_monitor/src/core/services/api_interceptor.dart';
import 'package:device_monitor/src/core/services/navigation_service.dart';
import 'package:device_monitor/src/core/services/token_service.dart';
import 'package:device_monitor/src/features/common/presentation/providers/provider_theme.dart';
import 'package:device_monitor/src/features/device/data/repositories/repository_device.dart';
import 'package:device_monitor/src/features/device/domain/interfaces/i_repository_device.dart';
import 'package:device_monitor/src/features/device/presentation/providers/provider_device_monitor.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {

  //using dependency-injection
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  ///REPOSITORIES
  //#region Repositories
  sl.registerLazySingleton<ICacheRepository>(() => CacheRepositoryImpl(sharedPreference: sl()));
  sl.registerLazySingleton<IRepositoryDevice>(() => RepositoryDevice(apiInterceptor: sl(), tokenService: sl()));
  //#endregion

  ///PROVIDERS
  //region Providers
  sl.registerFactory(() => ProviderDeviceMonitor(),);
  sl.registerFactory(() => ProviderTheme(),);

  //interceptors
  sl.registerLazySingleton<IApiInterceptor>(() => ApiInterceptor());

  ///services
  sl.registerSingleton(NavigationService());  //to initialize navigator-key for common-runtime
  sl.registerSingleton(TokenService()); //token service to store token common-runtime
  //logger
  sl.registerLazySingleton(()=>Logger(
    printer: PrettyPrinter(
      colors: false,
    ),
  ),);

}