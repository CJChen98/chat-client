import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/models/conversation.dart';
import 'package:flutter_web/models/index.dart';
import 'package:flutter_web/network/http_manager.dart';
import 'package:get_it/get_it.dart';

class ConversationsProvider with ChangeNotifier {
  Map<num, List<Message>> _conversations = Map();
  List<Conversation> _list = List();

  Map<num, List<Message>> get value => _conversations;

  List<Conversation> get list => _list;

  void add(Conversation conversation) {
    _conversations[conversation.ID] = List<Message>();
    _list.add(conversation);
    log("add ${conversation.ID}");
    notifyListeners();
  }

  Future<List<Message>> getMessageListByConversationID(num id) async {
    var list = List<Message>();
    if (_conversations.isNotEmpty) {
      _conversations.forEach((key, value) async {
        if (key == id) {
          list = _conversations[key].isEmpty
              ? await _fetchData(id)
              : _conversations[key];
        }
      });
    }
    return list;
  }

  reset() {
    _list.clear();
    _conversations.clear();
  }

  _fetchData(num id) async {
    List<Message> list = List();
    var _token = GetIt.instance<AppConfig>().token;
    var httpManager = GetIt.instance<HttpManager>();
    var parameters = {"type": "msg", "id": id, "page": 0};
    await httpManager.GET("/fetch/", token: _token, parameters: parameters,
        onSuccess: (data) {
      Chat chat;
      chat = Chat.fromJson(data);
      if (chat.code == 200) {
        list = chat.data.messages;
      }
    }, onError: (error) {
      log(error);
    });
    return _conversations[id]..addAll(list);
  }

  void insertNewMessage(num id, Message message) {
    if (_conversations.containsKey(id)) {
      _conversations[id].insert(0, message);
      notifyListeners();
    }
  }

  void addNewMessage(Message message) {
    if (_conversations.isEmpty) return;
    _conversations.forEach((key, value) {
      if (key == message.conversation_id) {
        insertNewMessage(message.conversation_id, message);
      }
    });
  }
}
