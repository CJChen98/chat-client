import 'package:flutter/foundation.dart';

class AppConfig {
  bool isBigScreen;
  Enviroment env = Enviroment.LOCAL;
  bool isWebPlatform = kIsWeb;
  String currentUserID;
  String username;
  String token;
  String avatar;

  String get apiHost {
    switch (env) {
      case Enviroment.LOCAL:
        return "http://127.0.0.1:1234";
      case Enviroment.DEV:
      case Enviroment.PROD:
        return "https://api.chitanda.cn";
      default:
        return "http://127.0.0.1:1234";
    }
  }
}

enum Enviroment { LOCAL, DEV, PROD }
