import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/models/chat.dart';
import 'package:flutter_web/network/http_manager.dart';
import 'package:flutter_web/utils/size_config.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _showPwd = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  FocusNode _usernameFocusNode = FocusNode();

  // FocusNode _passwordFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(title: Text("welcome to gin-chat~")),
      body: _loginBody(),
    );
  }

  _loginBody() {
    var width = 250.dp;
    var height = 200.dp;
    var paddingH = 30.dp;
    var paddingV = 30.dp;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        width = 100.dp;
        height = 100.dp;
        paddingH = 15.dp;
        paddingV = 25.dp;
      }
    } catch (e) {
      log(e.toString());
    }
    return Center(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey[50], width: 1),
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 8, spreadRadius: 0.1, color: Colors.grey)
            ],
            borderRadius: BorderRadius.all(Radius.circular(8.dp))),
        child: SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: EdgeInsets.only(
                top: paddingV,
                bottom: paddingV,
                left: paddingH,
                right: paddingH),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _usernameInput(),
                  SizedBox(),
                  _passwordInput(),
                  SizedBox(),
                  _loginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _loginButton() {
    return RaisedButton(
        onPressed: () {
          _doLogin();
        },
        color: Colors.blue,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(35))),
        child: Icon(Icons.keyboard_arrow_right));
  }
  _doLogin() async {
    var httpManager = GetIt.instance<HttpManager>();
    var data = {
      "username": _usernameController.text.trim(),
      "password": _passwordController.text.trim()
    };
    httpManager.POST("/login",data: data,onSuccess: (data){
      Chat chat;
      chat =Chat.fromJson(data);
      if(chat.code == 200){
        GetIt.instance<AppConfig>()..token =chat.token
        ..currentUserID=chat.data.user.ID;
        Navigator.of(context).pushNamed("Chat",arguments: chat);
      }
    },onError: (error){
      log(error);
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
