import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/network/websocket_manager.dart';
import 'package:flutter_web/ui/chat_detail.dart';
import 'package:flutter_web/ui/login_page.dart';
import 'package:flutter_web/ui/myhome_page.dart';
import 'package:get_it/get_it.dart';

void main() {
  GetIt.instance.registerSingleton(WebSocketManager());
  GetIt.instance.registerSingleton(AppConfig());
  var appConfig = GetIt.instance<AppConfig>();
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
    appConfig.isWebPlatform =true;
  }
  if (window.physicalSize.aspectRatio > 1) {
    appConfig.isBigScreen = true;
  } else {
    appConfig.isBigScreen = false;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        "Home": (context) => MyHomePage(
              title: ModalRoute.of(context).settings.arguments,
            ),
        "Chat": (context) => ChatDetailPage()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
