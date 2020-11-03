import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/models/message.dart';
import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  WebSocketChannel channel;

  Future<bool> connectToServer(
      String token, void callBack(Message message)) async {
    var appConfig = GetIt.instance<AppConfig>();
    var host = appConfig.apiHost;
    debugPrint("向服务器 $host 发起ws请求");
    Uri uri = Uri.parse("ws://${host.substring(7)}ws/?token=$token");
    channel = WebSocketChannel.connect(uri);
    channel.stream.listen((message) {
      debugPrint("收到服务器的消息: ${message.toString()}");
      Message m;
      m = Message.fromJson(json.decode(message));
      callBack(m);
    });
    if (channel == null) {
      return false;
    } else {
      return true;
    }
  }

  disconnect() async {
    channel.sink.close();
  }

  sendMessage(data) async {
    channel.sink.add(data);
  }

//外部添加监听
}
