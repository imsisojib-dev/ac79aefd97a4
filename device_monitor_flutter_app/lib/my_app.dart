import 'package:device_monitor/src/core/resources/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:device_monitor/src/core/application/navigation_service.dart';
import 'package:device_monitor/src/config/routes/router_helper.dart';
import 'package:device_monitor/src/config/routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'src/core/di/di_container.dart';

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
        return MaterialApp(
          navigatorKey: navigationService.navigatorKey,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return ScrollConfiguration(
              //Removes the whole app's scroll glow
              behavior: AppBehavior(),
              child: child!,
            );
          },
          title: 'Device Monitor',
          themeMode: ThemeMode.light,
          theme: AppTheme.lightTheme,
          initialRoute: Routes.homeScreen,
          onGenerateRoute: RouterHelper.router.generator,
        );
      },
    );
  }
}

//to avoid scroll glow in whole app
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