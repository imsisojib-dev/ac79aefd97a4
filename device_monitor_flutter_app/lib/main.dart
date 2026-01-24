import 'package:device_monitor/src/config/env.dart';
import 'package:flutter/material.dart';
import 'package:device_monitor/my_app.dart';
import 'package:device_monitor/src/core/application/token_service.dart';
import 'package:device_monitor/src/core/domain/interfaces/interface_cache_repository.dart';
import 'package:device_monitor/src/features/home/presentation/providers/provider_common.dart';
import 'src/core/di/di_container.dart' as di;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Env.baseUrl = '';
  Env.type = EEnvType.prod;

  await di.init();  //initializing Dependency Injection

  //update auth-token from cache [to check user logged-in or not]
  var token = di.sl<ICacheRepository>().fetchToken();
  di.sl<TokenService>().updateToken(token??"");  //update token will re-initialize wherever token was used

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di.sl<ProviderCommon>()),
      ],
      child: const MyApp(),
    ),
  );
}
