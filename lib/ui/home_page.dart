import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/models/chat.dart';
import 'package:flutter_web/network/http_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectIndex = 0;
  final List<Widget> _widgetList = <Widget>[
    _ConversationListPage(),
    _MinePage()
  ];
  static String _token = GetIt
      .instance<AppConfig>()
      .token;
  static String _username = GetIt
      .instance<AppConfig>()
      .username;
  static int _userID = GetIt
      .instance<AppConfig>()
      .currentUserID;

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
    _userID = int.parse(spf.getString("id") ?? "-1");
    return _token.isNotEmpty && _username.isNotEmpty && _userID != -1;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
      ),
      body: _widgetList[_selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Home"),
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

class _ConversationListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<_ConversationListPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (_, index) {
        if (index == 1)
          return RaisedButton(child: Text("new"), onPressed: _new);
        return _conversationItem(index);
      },
    );
  }

  _new() {
    var data = {
      "creator": _HomePageState._userID,
      "name": "room 1",
      "intro": "create room test"
    };
    GetIt.instance<HttpManager>().POST("/create/room",
        token: _HomePageState._token, data: data, onError: (err) {
          log(err.toString());
        }, onSuccess: (data) {
          Chat chat;
          chat = Chat.fromJson(data);
          if (chat.code == 200) {
            Fluttertoast.showToast(msg: chat.msg);
          }
        });
  }

  _conversationItem(int index) {
    _avatar() {
      return CircleAvatar(
          radius: 30, backgroundImage: AssetImage('assets/images/splash.png'));
    }

    _detail() {
      return Column(
        children: [Text("Room 1"), Text("啊吧啊吧")],
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("chat");
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(children: <Widget>[
          Expanded(flex: 1, child: _avatar()),
          Expanded(flex: 9, child: _detail()),
          Expanded(
            flex: 1,
            child: Icon(Icons.close),
          )
        ]),
      ),
    );
  }
}

class _MinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Expanded(
              flex: 1,
              child: Image(
                image: AssetImage('assets/images/splash.png'),
                width: 60,
                height: 60,
              )),
          Expanded(
            flex: 8,
            child: Text(_HomePageState._username),
          )
        ]),
        RaisedButton(
          child: Text("退出登录"),
          color: Colors.redAccent,
          onPressed: () {},
        )
      ],
    );
  }
}
