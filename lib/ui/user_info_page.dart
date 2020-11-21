import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/models/chat.dart';
import 'package:flutter_web/models/user.dart';
import 'package:flutter_web/network/http_manager.dart';
import 'package:flutter_web/ui/image_edit_page.dart';
import 'package:flutter_web/util/image_picker_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

class UserInfoPage extends StatefulWidget {
  static const String routName = "/userinfo";
  String uid;
  String tag;
  List<String> args;

  UserInfoPage({key, this.args}) : super(key: key) {
    uid = args.first;
    tag = args.last;
  }

  @override
  State<StatefulWidget> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  User user;

  AppConfig _appConfig = GetIt.instance<AppConfig>();
  double width;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    var query = {"type": "user", "id": widget.uid};
    GetIt.instance<HttpManager>().GET("/fetch/",
        token: _appConfig.token, query: query, onSuccess: (data) {
      var chat = Chat.fromJson(data);
      if (chat.code == 2002) {
        setState(() {
          user = chat.data.users.first;
        });
      }
    }, onError: (err) {
      log(err);
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return user == null
        ? Container()
        : Scaffold(
            body: NestedScrollView(
            headerSliverBuilder: (_, __) {
              return <Widget>[
                SliverAppBar(
                  // backgroundColor: Colors.transparent,
                  expandedHeight: width,
                  floating: true,
                  snap: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      "${user == null ? "--" : user.username}",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    background: Hero(
                        tag: widget.tag,
                        child: InkWell(
                          child: user == null
                              ? Image.asset(
                                  'assets/images/empty.png',
                                  fit: BoxFit.cover,
                                )
                              : FadeInImage.assetNetwork(
                                  fit: BoxFit.cover,
                                  image:
                                      "${_appConfig.apiHost}${user.avatar_path}",
                                  placeholder: 'assets/images/empty.png',
                                ),
                          onTap: _appConfig.currentUserID == widget.uid
                              ? () async {
                                  Uint8List result = await _pickImage();
                                  var url = await Navigator.of(context)
                                      .pushNamed(ImageEditPage.routName,
                                          arguments: result);
                                  setState(() {
                                    user..avatar_path=url;
                                  });
                                }
                              : null,
                        )),
                  ),
                )
              ];
            },
            body: ListView.builder(
              itemCount: 10,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text("item $index"),
                );
              },
            ),
          ));
  }

  _pickImage() async {
    final pickedFile = await ImagePickerUtil.pick();
    final Uint8List bytes = await pickedFile.readAsBytes();
    return bytes;
  }
}
