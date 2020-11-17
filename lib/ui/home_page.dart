import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
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
  static const String routName = "/home";

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
  static String _userID = GetIt.instance<AppConfig>().currentUserID;

  _initUserData() {
    _getValue().then((value) {
      if (value) {
        GetIt.instance<AppConfig>()
          ..currentUserID = _userID
          ..username = _username
          ..token = _token;
        // if (_conversationsModel.list.isEmpty)
        _fetchData();
        _initSocketManager();
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(LoginPage.routName, (route) => false);
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
    GetIt.instance<HttpManager>().GET("/fetch/", token: _token, query: query,
        onSuccess: (data) {
      var chat = Chat.fromJson(data);
      if (chat.code == 200) {
        chat.data.conversations.toList().forEach((element) {
          _conversationsModel.add(element);
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
      var bool = ModalRoute.of(context).isCurrent;
      log(bool.toString());
      _conversationsModel.addNewMessage(message, unread: bool);
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
        title: Text("Gin Chat"),
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
        return ListView.separated(
          physics: BouncingScrollPhysics(),
          itemCount: provider.length,
          itemBuilder: (context, index) {
            return Selector<ConversationsProvider, Conversation>(
              shouldRebuild: (previous, next) {
                log((previous == next).toString());
                return previous == next;
              },
              selector: (context, provider) => provider.list[index],
              builder: (context, data, child) {
                return _ConversationItem(data);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              height: 10,
              color: Colors.black54,
            );
          },
        );
      },
    );
  }
}

// ignore: must_be_immutable
class _ConversationItem extends StatefulWidget {
  Conversation conversation;

  _ConversationItem(this.conversation);

  @override
  State<StatefulWidget> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<_ConversationItem> {
  @override
  Widget build(BuildContext context) {
    return _conversationItem();
  }

  _conversationItem() {
    _avatar() {
      return Padding(
          padding: EdgeInsets.only(right: 10),
          child: CircleAvatar(
              minRadius: 10,
              maxRadius: 30,
              backgroundImage: AssetImage(
                'assets/images/splash.png',
              )));
    }

    _detail() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.3),
            child: Text(
              widget.conversation.title.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.3),
                child: Text(
                  widget.conversation.preview.toString(),
                  style: TextStyle(color: Colors.black54),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                )),
          ),
        ],
      );
    }

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ChatDetailPage.routName, arguments: widget.conversation);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(children: <Widget>[
          // Expanded(flex: 2, child: _avatar()),
          // Expanded(flex: 13, child: _detail()),
          _avatar(),
          Expanded(
            child: _detail(),
          ),
          widget.conversation.count != 0
              ? Text(widget.conversation.count.toString())
              : Text(""),
          // Expanded(
          //   flex: 1,
          //   child: widget.conversation.count != 0
          //       ? Text(widget.conversation.count.toString())
          //       : Text(""),
          // )
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
  ImageProvider _image = AssetImage('assets/images/splash.png');
  dynamic _previewImage = AssetImage('assets/images/splash.png');
  PickedFile _pickedFile;
  String _progress;
  Uint8List bytes;

  _pickImg() async {
    _pickedFile = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, maxHeight: 640, maxWidth: 640);
    _pickedFile.readAsBytes().then((value) {
      setState(() {
        bytes = value;
        _previewImage = MemoryImage(value);
      });
    });
  }

  _pickImageDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Pick Image"),
            content: Column(
              children: <Widget>[
                InkWell(onTap: _pickImg, child: Image(image: _previewImage)),
              ],
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  GetIt.instance<HttpManager>().Upload(_pickedFile, bytes,
                      query: {"type": "user"},
                      token: GetIt.instance<AppConfig>().token);
                },
                child: Text("Upload"),
              )
            ],
          );
        });
  }

  _avatar() {
    return InkWell(
      onTap: _pickImageDialog,
      child: Padding(
          padding: EdgeInsets.all(10),
          child: CircleAvatar(radius: 45, backgroundImage: _image)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          _avatar(),
          Flexible(
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
