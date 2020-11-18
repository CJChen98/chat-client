import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/data/conversations_provider.dart';
import 'package:flutter_web/data/user_info_provider.dart';
import 'package:flutter_web/models/chat.dart';
import 'package:flutter_web/network/http_manager.dart';
import 'package:flutter_web/ui/home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static const String routName = "/login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _showPwd = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  FocusNode _usernameFocusNode = FocusNode();
  Size _size;

  ConversationsProvider provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ConversationsProvider>(context);

    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("welcome to gin-chat~")),
      body: _loginBody(),
    );
  }

  _loginBody() {
    var width = _size.width / 4;
    var height = width / 5 * 4;
    try {
      if (window.physicalSize.aspectRatio < 1) {
        width = _size.height / 8 * 3;
        height = width / 5 * 4;
      }
    } catch (e) {
      log(e.toString());
    }
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 35,
                  spreadRadius: 0.1,
                  color: Color.fromARGB(255, 213, 216, 220))
            ],
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: SizedBox(
          width: width,
          height: height,
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _userAvatar(),
                _usernameInput(),
                _passwordInput(),
                _loginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _userAvatar() {
    return CircleAvatar(
      radius: 25,
      backgroundImage: AssetImage('assets/images/splash.png'),
    );
  }

  _loginButton() {
    return RaisedButton(
        onPressed: () {
          if (_usernameController.value.text.trim().length < 2 ||
              _passwordController.value.text.isEmpty) return;
          if (_passwordController.value.text.contains(" ")) {
            Fluttertoast.showToast(msg: "密码不能使用空格");
          }
          _doLogin();
        },
        color: Colors.blue,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Icon(Icons.keyboard_arrow_right));
  }

  _doLogin() async {
    var httpManager = GetIt.instance<HttpManager>();
    var data = {
      "username": _usernameController.text.trim(),
      "password": _passwordController.text.trim()
    };
    httpManager.POST("/login", data: data, onSuccess: (data) async {
      Chat chat;
      chat = Chat.fromJson(data);
      Fluttertoast.showToast(msg: chat.msg);
      if (chat.code == 200) {
        Provider.of<UserInfoProvider>(context, listen: false)
            .set(chat.data.users.first, token: chat.token);
        provider.reset();
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomePage.routName, (_) => false);
      }
    }, onError: (err) {
      log(err);
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  _usernameInput() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Username",
          hintText: "Please input your username",
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _usernameController.clear();
            },
          ),
          isDense: true),
      // style: Theme.of(context).primaryTextTheme.headline6,
      controller: _usernameController,
      focusNode: _usernameFocusNode,
    );
  }

  _passwordInput() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Password",
          hintText: "Please input your password",
          prefixIcon: Icon(Icons.account_box),
          suffixIcon: IconButton(
            icon: Icon(_showPwd ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showPwd = !_showPwd;
              });
            },
          ),
          isDense: true),
      controller: _passwordController,
      obscureText: !_showPwd,
    );
  }
}
