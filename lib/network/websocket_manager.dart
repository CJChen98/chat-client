import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/generated/json/chat_entity_helper.dart';
import 'package:flutter_web/model/entity.dart';
import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketManager {
  IOWebSocketChannel channel;
  List<Message> messageList = List();
  ObserverList<OnReceiveMessage> observerList =
      ObserverList<OnReceiveMessage>();

  Future<bool> connectToServer(String token) async {
    var host = GetIt.instance<AppConfig>().apiHost;
    debugPrint("向服务器 $host 发起ws请求");
    channel = IOWebSocketChannel.connect("ws://${host.substring(7)}/ws",
        headers: {'Authorization': 'Bearer $token'});
    channel.stream.listen((message) {
      debugPrint("收到服务器的消息: ${message.toString()}");
      var m = json.decode(message);
      messageList.add(messageFromJson(Message(), m));
      observerList.forEach((OnReceiveMessage listener) {
        listener(m);
      });
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

  Future<bool> sendMessage(Map<String, dynamic> data) async {
    channel.sink.add(data);
  }

  //外部添加监听
  addListener(OnReceiveMessage listener) {
    if (observerList.contains(listener)) {
      return;
    }
    observerList.add(listener);
  }

  removeListener(OnReceiveMessage listener) {
    observerList.remove(listener);
  }
}

typedef OnReceiveMessage(Map<String, dynamic> json);
