class AppConfig {
  bool isBigScreen;
  Enviroment env = Enviroment.LOCAL;
  bool isWebPlatform = false;
  num currentUserID;
  String username;
  String token;
  String get apiHost {
    switch (env) {
      case Enviroment.LOCAL:
        return "http://192.168.3.217/api/v1/";
      case Enviroment.DEV:
      case Enviroment.PROD:
        return "https://api.chitanda.cn";
    }
  }
}

enum Enviroment { LOCAL, DEV, PROD }
