import 'dart:async';
import 'dart:developer';
import 'dart:html' as html;
import 'dart:io';

import 'package:flutter/cupertino.dart';

// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/data/conversations_provider.dart';
import 'package:flutter_web/models/chat.dart';
import 'package:flutter_web/models/conversation.dart';
import 'package:flutter_web/network/http_manager.dart';
import 'package:flutter_web/network/websocket_manager.dart';
import 'package:flutter_web/ui/chat_detail.dart';
import 'package:flutter_web/ui/login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static String routName = "/home";

  const HomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectIndex = 0;
  WebSocketManager _socketManager = WebSocketManager();
  final List<Widget> _widgetList = <Widget>[
    _ConversationListPage(),
    _MinePage()
  ];
  static String _token = GetIt.instance<AppConfig>().token;
  static String _username = GetIt.instance<AppConfig>().username;
  static int _userID = GetIt.instance<AppConfig>().currentUserID;

  _initUserData() {
    _getValue().then((value) {
      if (value) {
        GetIt.instance<AppConfig>()
          ..currentUserID = _userID
          ..username = _username
          ..token = _token;
        if (_conversationsModel.list.isEmpty) _fetchData();
        _initSocketManager();
      }
    });
  }

  Future<bool> _getValue() async {
    final spf = await SharedPreferences.getInstance();
    _token = spf.getString("token");
    _username = spf.getString("username");
    _userID = int.parse(spf.getString("id") ?? "-1");
    return _token.isNotEmpty && _username.isNotEmpty && _userID != -1;
  }

  @override
  void initState() {
    _initUserData();
    super.initState();
  }

  Future<Conversation> _createConversationDialog(BuildContext context) async {
    Future<Conversation> _new(String name) async {
      var data = {
        "creator": _HomePageState._userID,
        "name": name,
        "intro": "create room test"
      };
      Conversation conversation;
      await GetIt.instance<HttpManager>().POST("/create/room",
          token: _HomePageState._token, data: data, onError: (err) {
        log(err.toString());
      }, onSuccess: (data) {
        Chat chat;
        chat = Chat.fromJson(data);
        if (chat.code == 200) {
          Fluttertoast.showToast(msg: chat.msg);
          conversation = chat.data.conversations.first;
        }
      });
      return conversation;
    }

    var controller = TextEditingController();
    return await showDialog<Conversation>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("请输入名称"),
          content: TextField(
            controller: controller,
          ),
          actions: <Widget>[
            FlatButton(
                child: Text("cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            FlatButton(
              child: Text("ok"),
              onPressed: () async {
                if (controller.value.text.isEmpty) return;
                var c = await _new(controller.value.text);
                Navigator.of(context).pop(c);
              },
            )
          ],
        );
      },
    );
  }

  ConversationsProvider _conversationsModel;

  _fetchData() async {
    var query = {"type": "home", "id": _userID};
    GetIt.instance<HttpManager>()
        .GET("/fetch/", token: _token, parameters: query, onSuccess: (data) {
      var chat = Chat.fromJson(data);
      if (chat.code == 200) {
        setState(() {
          chat.data.conversations.toList().forEach((element) {
            _conversationsModel.add(element);
          });
        });
      }
    }, onError: (err) {
      log(err);
    });
  }

  _initSocketManager() async {
    await _socketManager.disconnect();
    if (_token == null) {
      Navigator.of(context).pushReplacementNamed("login");
      return;
    }
    _socketManager.connectToServer(_token, onSuccess: (message) {
      _conversationsModel.addNewMessage(message);
    }, onError: () {
      print("ws create failure");
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _conversationsModel = Provider.of<ConversationsProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
      ),
      body: _widgetList[_selectIndex],
      floatingActionButton: _selectIndex == 0
          ? FloatingActionButton(
              onPressed: () async {
                var c = await _createConversationDialog(context);
                _conversationsModel.add(c);
              },
              child: Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Message"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Mine"),
        ],
        currentIndex: _selectIndex,
        onTap: (position) {
          setState(() {
            _selectIndex = position;
          });
        },
      ),
    );
  }
}

class _ConversationListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<ConversationsProvider, List<Conversation>>(
      shouldRebuild: (previous, next) => previous == next,
      selector: (context, provider) => provider.list,
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.length,
          itemBuilder: (context, index) {
            return Selector<ConversationsProvider, Conversation>(
              selector: (context, provider) => provider.list[index],
              builder: (context, data, child) {
                return ConversationItem(data);
              },
            );
          },
        );
      },
    );
  }
}

class ConversationItem extends StatefulWidget {
  Conversation conversation;

  ConversationItem(this.conversation);

  @override
  State<StatefulWidget> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  String title;
  String avatar;

  _init() {
    var query = {
      "type": widget.conversation.private ? "user" : "room",
      "id": widget.conversation.receiver_id
    };
    GetIt.instance<HttpManager>().GET("/fetch/",
        token: _HomePageState._token, parameters: query, onSuccess: (data) {
      var chat = Chat.fromJson(data);
      setState(() {
        if (chat.code == 2001) {
          title = chat.data.rooms.first.room_name;
        }
        if (chat.code == 2002) {
          title = chat.data.users.first.username;
        }
      });
    }, onError: (err) {
      log(err);
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return _conversationItem();
  }

  _conversationItem() {
    _avatar() {
      return Padding(
          padding: EdgeInsets.all(8),
          child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/splash.png')));
    }

    _detail() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(title.toString()), Text("啊吧啊吧")],
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ChatDetailPage.routName, arguments: widget.conversation);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(children: <Widget>[
          Expanded(flex: 2, child: _avatar()),
          Expanded(flex: 11, child: _detail()),
          Expanded(
            flex: 1,
            child: Icon(Icons.close),
          )
        ]),
      ),
    );
  }
}

class _MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MinePageState();
}

class _MinePageState extends State<_MinePage> {
  ImageProvider image = AssetImage('assets/images/splash.png');

  _selectImg() async {
    if (kIsWeb) {
      var uploadInput = html.FileUploadInputElement();
      uploadInput.accept = "images/*";
    } else {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      File file = File(pickedFile.path);
    }
  }

  _avatar() {
    return GestureDetector(
      onTap: _selectImg,
      child: Padding(
          padding: EdgeInsets.all(10),
          child: CircleAvatar(radius: 40, backgroundImage: image)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Expanded(
            flex: 3,
            child: _avatar(),
          ),
          Expanded(
            flex: 12,
            child: Text(_HomePageState._username),
          )
        ]),
        RaisedButton(
          child: Text("退出登录"),
          color: Colors.redAccent,
          onPressed: () {
            Navigator.of(context).pushNamed(LoginPage.routName);
          },
        )
      ],
    );
  }
}
