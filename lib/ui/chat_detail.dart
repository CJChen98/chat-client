import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/models/chat.dart';
import 'package:flutter_web/models/index.dart';
import 'package:flutter_web/models/message.dart';
import 'package:flutter_web/network/http_manager.dart';
import 'package:flutter_web/network/websocket_manager.dart';
import 'package:flutter_web/ui/widget/bubble_widget.dart';
import 'package:get_it/get_it.dart';

// ignore: must_be_immutable
class ChatDetailPage extends StatefulWidget {
  Chat chat;

  ChatDetailPage({this.chat});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  WebSocketManager socketManager;
  int page = 0;
  List<Message> _messages = List<Message>();
  ScrollController _scrollController = ScrollController();
  bool newMessage = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
    socketManager = GetIt.instance<WebSocketManager>();
    socketManager.connectToServer(GetIt.instance<AppConfig>().token,
        onSuccess: (message) {
      setState(() {
        _messages.insert(0, message);
        Timer(
            Duration(milliseconds: 500),
            () => {
                  _scrollController.animateTo(
                      _scrollController.position.minScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease)
                });
      });
    }, onError: () {
      print("ws create failure");
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!isLoading &&page < maxPage) {
          page++;
          _fetchData();
        }
      }
    });
  }

  @override
  void dispose() {
    socketManager.disconnect();
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
              ..username = widget.chat.data.user.username
              ..content = _inputController.value.text
              ..room_id = 1
              ..user_id = widget.chat.data.user.ID;
            socketManager.sendMessage(json.encode(message));
            _inputController.clear();
          },
          icon: Icon(Icons.send),
        )
      ],
    );
  }

  _messageList() {
    return Flexible(
        child: ListView.builder(
      reverse: true,
      physics: BouncingScrollPhysics(),
      controller: _scrollController,
      itemCount:
          _messages == null ?? _messages.length == 0 ? 0 : _messages.length,
      itemBuilder: (context, index) {
        return BubbleWidget(_messages.elementAt(index));
      },
    ));
  }

  int maxPage;

  _fetchData() async {
    isLoading = true;
    var httpManager = GetIt.instance<HttpManager>();
    var parameters = {"kind": "room_msg", "id": 1, "page": page};
    httpManager.GET("/find/",
        token: GetIt.instance<AppConfig>().token,
        parameters: parameters, onSuccess: (data) {
      Chat chat;
      chat = Chat.fromJson(data);
      if (chat.code == 200) {
        maxPage = int.parse(chat.msg);
        setState(() {
          isLoading = false;
          _messages.addAll(chat.data.messages);
        });
        if (chat.code == 404) {
          maxPage = int.parse(chat.msg);
          page = maxPage;
          isLoading = false;
        }
      }
    }, onError: (error) {
      log(error);
    });
  }

  _main() {
    // var channel = IOWebSocketChannel.connect("")
    return Column(
      children: <Widget>[
        _messageList(),
        _bottomInputBar(),
      ],
    );
  }
}
