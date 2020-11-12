import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/models/chat.dart';
import 'package:flutter_web/network/http_manager.dart';
import 'package:flutter_web/ui/home_page.dart';
import 'package:flutter_web/ui/login_page.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  HttpManager httpManager = GetIt.instance<HttpManager>();

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    super.initState();
    _controller.repeat();
    Future.delayed(Duration(seconds: 2), () {
      _checkUserData();
    });
  }

  _checkUserData() async {
    var token = await _getSharedPreferences("token");
    var username = await _getSharedPreferences("username");
    var id = await _getSharedPreferences("id");
    if (token == null || username == null || id == null) {
      Navigator.of(context).pushReplacementNamed(LoginPage.routName);
    } else {
      GetIt.instance<AppConfig>()
        ..username = username
        ..token = token
        ..currentUserID = int.parse(id);
      _checkToken(token);
    }
  }

  _getSharedPreferences(String key) async {
    var spf = await SharedPreferences.getInstance();
    return spf.getString(key);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _checkToken(String token) async {
    var httpManager = GetIt.instance<HttpManager>();
    httpManager.GET("/", token: token, onSuccess: (data) {
      Chat chat;
      chat = Chat.fromJson(data);
      if (chat.code > 0) {
        Navigator.of(context).pushReplacementNamed(HomePage.routName);
      } else {
        Navigator.of(context).pushReplacementNamed(LoginPage.routName);
      }
    }, onError: (_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RotationTransition(
            child: Image.asset(
              'assets/images/splash.png',
              height: 80,
              width: 80,
            ),
            alignment: Alignment.center,
            turns: _controller,
          ),
          Container(
            child: Text(
              "=w=",
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
