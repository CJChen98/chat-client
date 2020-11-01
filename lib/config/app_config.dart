class AppConfig {
  bool isBigScreen;
  Enviroment env = Enviroment.LOCAL;
  bool isWebPlatform = false;

  String get apiHost {
    switch (env) {
      case Enviroment.LOCAL:
        return "http://192.168.124.55/api/v1/";
      case Enviroment.DEV:
      case Enviroment.PROD:
        return "http://chitanda.cn/api/v1";
    }
  }
}

enum Enviroment { LOCAL, DEV, PROD }
