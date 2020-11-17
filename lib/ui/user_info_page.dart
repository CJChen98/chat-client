import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  static const String routName = "/userinfo";

  String uid;

  UserInfoPage({key, this.uid}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
