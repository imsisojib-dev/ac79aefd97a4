import 'package:device_monitor/src/core/di/di_container.dart';
import 'package:device_monitor/src/features/analytics/presentation/providers/provider_analytics.dart';
import 'package:device_monitor/src/features/analytics/presentation/screen_analytics.dart';
import 'package:device_monitor/src/features/history/presentation/providers/provider_history.dart';
import 'package:device_monitor/src/features/history/presentation/screen_history.dart';
import 'package:device_monitor/src/features/splash/screens/splash_screen.dart';
import 'package:fluro/fluro.dart';
import 'package:device_monitor/src/features/errors/presentation/screens/screen_error.dart';
import 'package:device_monitor/src/features/home/presentation/screens/screen_home.dart';
import 'package:device_monitor/src/config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouterHelper {
  static final FluroRouter router = FluroRouter();

  ///Handlers
  static final Handler _homeScreenHandler = Handler(handlerFunc: (context, Map<String, dynamic> parameters) {
    return const ScreenHome();
  });

  static final Handler _splashScreenHandler = Handler(handlerFunc: (context, Map<String, dynamic> parameters) {
    return const SplashScreen();
  });

  static final Handler _historyScreenHandler = Handler(handlerFunc: (context, Map<String, dynamic> parameters) {
    String? deviceId = ModalRoute.of(context!)!.settings.arguments as String?;
    if (deviceId?.isEmpty ?? true) {
      return ScreenError(
        message: 'Device id is missing!',
      );
    }

    return ChangeNotifierProvider(
      create: (_) => sl<ProviderHistory>(),
      child: ScreenHistory(
        deviceId: deviceId!,
      ),
    );
  });

  static final Handler _analyticsScreenHandler = Handler(handlerFunc: (context, Map<String, dynamic> parameters) {
    String? deviceId = ModalRoute.of(context!)!.settings.arguments as String?;
    if (deviceId?.isEmpty ?? true) {
      return ScreenError(
        message: 'Device id is missing!',
      );
    }

    return ChangeNotifierProvider(
      create: (_) => sl<ProviderAnalytics>(),
      child: ScreenAnalytics(
        deviceId: deviceId!,
      ),
    );
  });

  static final Handler _notFoundHandler = Handler(
    handlerFunc: (context, parameters) => ScreenError(
      message: 'Unable to find the requested page!',
    ),
  );

  void setupRouter() {
    router.notFoundHandler = _notFoundHandler;

    //main flow
    router.define(Routes.homeScreen, handler: _homeScreenHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.splashScreen, handler: _splashScreenHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.historyScreen, handler: _historyScreenHandler, transitionType: TransitionType.cupertino);
    router.define(Routes.analyticsScreen, handler: _analyticsScreenHandler, transitionType: TransitionType.cupertino);
  }
}
