import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/models/message.dart';
import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  WebSocketChannel _chanel;
  static WebSocketManager _instance;

  AppConfig appConfig;

  String host;
  Uri uri;

  static WebSocketManager get instance => _instance;

  factory WebSocketManager() => _getInstance();

  WebSocketManager._() {
    appConfig = GetIt.instance<AppConfig>();
    host = appConfig.apiHost;
  }

  static WebSocketManager _getInstance() {
    if (_instance == null) {
      _instance = WebSocketManager._();
    }
    return _instance;
  }

  connectToServer(String token,
      {Function(Message message) onSuccess, Function onError}) async {
    if (appConfig.env == Enviroment.LOCAL) {
      uri = Uri.parse("ws${host.substring(4)}/ws/?token=$token");
    } else {
      uri = Uri.parse("wss${host.substring(5)}/ws/?token=$token");
    }
    debugPrint("向$uri 发起请求");
    _chanel = WebSocketChannel.connect(uri);
    _chanel.stream.listen((message) {
      debugPrint("收到服务器的消息: ${message.toString()}");
      onSuccess(Message.fromJson(json.decode(message)));
    });
  }

  disconnect() async {
    if (_chanel != null) _chanel.sink.close();
  }

  sendMessage(data) async {
    _chanel.sink.add(data);
  }
}
