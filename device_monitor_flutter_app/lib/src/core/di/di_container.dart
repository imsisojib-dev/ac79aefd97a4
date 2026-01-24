import 'package:device_monitor/src/config/app_config.dart';
import 'package:device_monitor/src/config/env.dart';
import 'package:device_monitor/src/core/application/api_interceptor.dart';
import 'package:device_monitor/src/core/application/navigation_service.dart';
import 'package:device_monitor/src/core/application/token_service.dart';
import 'package:device_monitor/src/core/data/repositories/cache_repository_impl.dart';
import 'package:device_monitor/src/core/domain/interfaces/interface_api_interceptor.dart';
import 'package:device_monitor/src/core/domain/interfaces/interface_cache_repository.dart';
import 'package:device_monitor/src/features/home/presentation/providers/provider_common.dart';
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
  //#endregion

  ///USE-CASES


  ///END of USE-CASES

  ///PROVIDERS
  //region Providers
  sl.registerFactory(() => ProviderCommon(),);

  //interceptors
  sl.registerLazySingleton<IApiInterceptor>(() => ApiInterceptor(baseUrl: Env.baseUrl));

  ///services
  sl.registerSingleton(NavigationService());  //to initialize navigator-key for app-runtime
  sl.registerSingleton(TokenService()); //token service to store token app-runtime
  //logger
  sl.registerLazySingleton(()=>Logger(
    printer: PrettyPrinter(
      colors: false,
    ),
  ),);

}