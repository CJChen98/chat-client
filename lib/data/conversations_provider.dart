import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/models/conversation.dart';
import 'package:flutter_web/models/index.dart';
import 'package:flutter_web/network/http_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

class ConversationsProvider with ChangeNotifier {
  Map<String, List<Message>> _conversations = Map();
  List<Conversation> _list = List();

  Map<String, List<Message>> get value => _conversations;

  List<Conversation> get list => _list;

  void add(Conversation conversation) {
    if (_conversations.containsKey(conversation.receiver_id)) return;
    _conversations[conversation.receiver_id] = List<Message>();
    _list.add(conversation);
    _fetchData(conversation);
    notifyListeners();
  }

  Future<List<Message>> getMessageListByConversation(
      Conversation conversation) async {
    if (_conversations.containsKey(conversation.receiver_id)) {
      return _conversations[conversation.receiver_id].isEmpty
          ? await _fetchData(conversation)
          : _conversations[conversation.receiver_id];
    } else {
      return List<Message>();
    }
  }

  reset() {
    _list.clear();
    _conversations.clear();
  }

  _fetchData(Conversation conversation) async {
    var _token = GetIt
        .instance<AppConfig>()
        .token;
    var httpManager = GetIt.instance<HttpManager>();
    var query = {
      "type": conversation.private ? "user" : "room",
      "id": conversation.receiver_id
    };
    String title;
    String avatar;
    await httpManager.GET("/fetch/", token: _token, query: query,
        onSuccess: (data) {
          var chat = Chat.fromJson(data);
          if (chat.code == 2001) {
            title = chat.data.rooms.first.room_name;
            avatar = chat.data.rooms.first.avatar_path;
          }
          if (chat.code == 2002) {
            title = chat.data.users.first.username;
            avatar = chat.data.users.first.avatar_path;
          }
        }, onError: (error) {
          log("fetch home err ====>" + error.toString());
        });
    List<Message> list = List();
    var parameters = {"type": "msg", "id": conversation.receiver_id, "page": 0};
    await httpManager.GET("/fetch/", token: _token, query: parameters,
        onSuccess: (data) {
          Chat chat;
          chat = Chat.fromJson(data);
          if (chat.code == 200) {
            list = chat.data.messages.toList();
          }
        }, onError: (error) {
          log("fetch msg err ====>" + error.toString());
        });
    if (list.isNotEmpty) {
      _updateConversation(conversation.receiver_id,
          msg: list.first, title: title, avatar: avatar);
    } else {
      _updateConversation(conversation.receiver_id,
          title: title, avatar: avatar);
    }
    return _conversations[conversation.receiver_id]
      ..addAll(list);
  }

  void _updateConversation(String id,
      {Message msg, String title, String avatar, unread = false}) {
    for (var value in _list) {
      if (value.receiver_id == id) {
        if (msg != null) {
          value.preview = "${msg.username}: ${msg.content}${msg.image_url.isNotEmpty?"[图片]":""}";
          if (unread) {
            value.count++;
          }
        }
        if (title != null) {
          value.title = title;
        }
        if (avatar != null) {
          value.avatar = GetIt
              .instance<AppConfig>()
              .apiHost + avatar;
        }
      }
    }
    notifyListeners();
  }

  void clearUnread(String id) {
    for (var i = 0; i < _list.length; i++) {
      if (_list[i].receiver_id == id) {
        _list[i].count = 0;
        notifyListeners();
        break;
      }
    }
  }

  void addOldMessage(Message message) {
    if (_conversations.containsKey(message.receiver_id)) {
      _conversations[message.receiver_id].add(message);
      notifyListeners();
    }
  }

  void addNewMessage(Message message, {unread = false}) {
    if (_conversations.containsKey(message.receiver_id)) {
      _conversations[message.receiver_id].insert(0, message);
      _updateConversation(message.receiver_id, msg: message, unread: unread);
      notifyListeners();
    }
  }

  void updateMessage(String conversation, Message message) {
    if (_conversations.containsKey(conversation)) {
      for (var value in _conversations[conversation]) {
        if (value.ID == message.ID) {
          value = message;
          break;
        }
      }
    }
    notifyListeners();
  }
}
