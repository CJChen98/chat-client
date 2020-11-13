import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/data/conversations_provider.dart';
import 'package:flutter_web/models/chat.dart';
import 'package:flutter_web/models/index.dart';
import 'package:flutter_web/models/message.dart';
import 'package:flutter_web/network/http_manager.dart';
import 'package:flutter_web/network/websocket_manager.dart';
import 'package:flutter_web/ui/widget/bubble_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ChatDetailPage extends StatefulWidget {
  static String routName = "/chat";

  Conversation conversation;

  ChatDetailPage(this.conversation);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  String _token = GetIt.instance<AppConfig>().token;
  String _username = GetIt.instance<AppConfig>().username;
  String _userID = GetIt.instance<AppConfig>().currentUserID;
  int _page = 0;
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  _initUserData() {
    _getValue().then((value) {
      if (value) {
        GetIt.instance<AppConfig>()
          ..currentUserID = _userID
          ..username = _username
          ..token = _token;
      }
    });
  }

  Future<bool> _getValue() async {
    final spf = await SharedPreferences.getInstance();
    _token = spf.getString("token");
    _username = spf.getString("username");
    _userID = spf.getString("id");
    return _token.isNotEmpty && _username.isNotEmpty && _userID.isNotEmpty;
  }

  ConversationsProvider _conversationsProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initUserData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!_isLoading) {
          _page++;
          _fetchData();
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _conversationsProvider =
          Provider.of<ConversationsProvider>(context, listen: false);
      _conversationsProvider.clearUnread(widget.conversation.receiver_id);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("chat~")),
      body: _main(),
    );
  }

  _bottomInputBar() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 10, spreadRadius: 0.1, color: Colors.grey)
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      child: Padding(
        padding: EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
        child: Column(
          children: <Widget>[_inputToolBar(), _inputTextField()],
        ),
      ),
    );
  }

  _inputToolBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.mic, color: Colors.blue),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.image, color: Colors.blue),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.emoji_emotions, color: Colors.blue),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.code, color: Colors.blue),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.add_circle, color: Colors.blue),
        ),
      ],
    );
  }

  var _inputController = TextEditingController();

  _inputTextField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
            child: TextField(
          decoration: InputDecoration(hintText: "Say something ..."),
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 15,
          controller: _inputController,
        )),
        IconButton(
          onPressed: () {
            if (_inputController.value.text.isEmpty) {
              return;
            }
            var message = Message()
              ..username = _username
              ..content = _inputController.value.text
              ..conversation_id = widget.conversation.ID
              ..receiver_id = widget.conversation.receiver_id
              ..user_id = _userID;
            try {
              WebSocketManager.instance.sendMessage(json.encode(message));
            } catch (e) {
              log(e.toString());
            }
            _inputController.clear();
          },
          icon: Icon(Icons.send),
        )
      ],
    );
  }

  _messageListView() {
    return Selector<ConversationsProvider, Map<String, List<Message>>>(
      shouldRebuild: (previous, next) => previous == next,
      selector: (_, provider) => provider.value,
      builder: (_, provider, __) {
        return Flexible(
          child: ListView.builder(
            reverse: true,
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            itemCount: provider[widget.conversation.receiver_id].length,
            itemBuilder: (_, index) {
              return Selector<ConversationsProvider, Message>(
                shouldRebuild: (previous, next) => previous == next,
                selector: (_, provider) =>
                    provider.value[widget.conversation.receiver_id][index],
                builder: (_, message, __) {
                  return BubbleWidget(message);
                },
              );
            },
          ),
        );
      },
    );
  }

  int maxPage = 1;

  _fetchData() async {
    if (_token == null) {
      Navigator.of(context).pushReplacementNamed("login");
      return;
    }
    _isLoading = true;
    var httpManager = GetIt.instance<HttpManager>();
    var parameters = {
      "type": "msg",
      "id": widget.conversation.receiver_id,
      "page": _page
    };
    httpManager.GET("/fetch/", token: _token, parameters: parameters,
        onSuccess: (data) {
      Chat chat = Chat.fromJson(data);
      if (chat.code == 200) {
        maxPage = int.parse(chat.msg);
        chat.data.messages.toList().forEach((element) {
          _conversationsProvider.addOldMessage(element);
        });
      }
      if (chat.code == 404) {
        maxPage = int.parse(chat.msg);
        _page = maxPage;
      }
      _isLoading = false;
    }, onError: (error) {
      log(error);
      _isLoading = false;
    });
  }

  _main() {
    // var channel = IOWebSocketChannel.connect("")
    return Column(
      children: <Widget>[
        _messageListView(),
        _bottomInputBar(),
      ],
    );
  }
}
