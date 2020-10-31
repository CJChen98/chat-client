class AppConfig {
  bool isBigScreen;
  Enviroment env = Enviroment.LOCAL;
  String get apiHost {
    switch (env) {
      case Enviroment.LOCAL:
        return "http://127.0.0.1/api/v1/";
      case Enviroment.DEV:
      case Enviroment.PROD:
        return "http://chitanda.cn/api/v1";
    }
  }
}

enum Enviroment { LOCAL, DEV, PROD }
