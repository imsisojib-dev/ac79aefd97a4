import 'package:device_monitor/src/core/services/navigation_service.dart';
import 'package:device_monitor/src/core/services/token_service.dart';
import 'package:device_monitor/src/features/common/presentation/providers/provider_theme.dart';
import 'package:device_monitor/src/features/home/presentation/providers/provider_home.dart';
import 'package:flutter/material.dart';
import 'package:device_monitor/src/config/routes/router_helper.dart';
import 'package:device_monitor/src/config/routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:device_monitor/src/core/domain/interfaces/interface_cache_repository.dart';
import 'package:device_monitor/src/features/device/presentation/providers/provider_device_monitor.dart';
import 'src/config/resources/app_theme.dart';
import 'src/core/di/di_container.dart' as di;
import 'src/core/di/di_container.dart';

Future<void> initApp()async{
  await di.init();  //initializing Dependency Injection

  //update auth-token from cache [to check user logged-in or not]
  var token = di.sl<ICacheRepository>().fetchToken();
  di.sl<TokenService>().updateToken(token??"");  //update token will re-initialize wherever token was used

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di.sl<ProviderDeviceMonitor>()),
        ChangeNotifierProvider(create: (_) => di.sl<ProviderTheme>()),
        ChangeNotifierProvider(create: (_) => di.sl<ProviderHome>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NavigationService navigationService = sl();


  @override
  void initState() {
    super.initState();
    RouterHelper().setupRouter();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, app) {
        return Consumer<ProviderTheme>(builder: (_, themeProvider, child){
          return MaterialApp(
            navigatorKey: navigationService.navigatorKey,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return ScrollConfiguration(
                //Removes the whole common's scroll glow
                behavior: AppBehavior(),
                child: child!,
              );
            },
            title: 'Device Monitor',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: Routes.splashScreen,
            onGenerateRoute: RouterHelper.router.generator,
          );
        });
      },
    );
  }
}

//to avoid scroll glow in whole common
class AppBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context,
      Widget child,
      AxisDirection axisDirection,
      ) {
    return child;
  }
}