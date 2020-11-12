import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/data/conversations_provider.dart';
import 'package:flutter_web/network/http_manager.dart';
import 'package:flutter_web/network/websocket_manager.dart';
import 'package:flutter_web/ui/chat_detail.dart';
import 'package:flutter_web/ui/home_page.dart';
import 'package:flutter_web/ui/login_page.dart';
import 'package:flutter_web/ui/splash_page.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

void main() {
  GetIt.instance.registerSingleton(AppConfig());
  var appConfig = GetIt.instance<AppConfig>();
  appConfig.env = Enviroment.LOCAL;
  // GetIt.instance.registerSingleton(WebSocketManager());
  GetIt.instance.registerSingleton(HttpManager());
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent));
      appConfig.isWebPlatform = false;
    } else {
      appConfig.isWebPlatform = true;
    }
  } catch (e) {
    log(e.toString());
    appConfig.isWebPlatform = true;
  }
  if (window.physicalSize.aspectRatio > 1) {
    appConfig.isBigScreen = true;
  } else {
    appConfig.isBigScreen = false;
  }
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ConversationsProvider())],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      routes: {
        LoginPage.routName: (context) => LoginPage(),
        ChatDetailPage.routName: (context) =>
            ChatDetailPage(ModalRoute.of(context).settings.arguments),
        HomePage.routName: (context) => HomePage()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
    );
  }
}
