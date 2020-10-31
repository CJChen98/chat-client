import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web/ui/chat_detail.dart';
import 'package:flutter_web/ui/login_page.dart';
import 'package:flutter_web/ui/myhome_page.dart';

void main() {
  runApp(MyApp());
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent));
    }
  } catch (e) {
    log(e.toString());
  }
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
        "Chat": (context) => ChatPage()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
