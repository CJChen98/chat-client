import 'dart:developer';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/data/user_info_provider.dart';
import 'package:flutter_web/models/chat.dart';
import 'package:flutter_web/network/http_manager.dart';
import 'package:flutter_web/util/image/image_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ImageEditPage extends StatefulWidget {
  static String routName = "/edit_image";

  @override
  State<StatefulWidget> createState() => _ImageEditPageState();
}

class _ImageEditPageState extends State<ImageEditPage> {
  final GlobalKey<ExtendedImageEditorState> _editorKey =
      GlobalKey<ExtendedImageEditorState>();
  Uint8List _bytes;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _bytes = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            child: Text("Upload"),
            onPressed: () {
              _upload();
              _isCropping = false;
            },
          )
        ],
      ),
      body: _body(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.aspect_ratio), label: "Clip"),
          BottomNavigationBarItem(
              icon: Icon(Icons.rotate_left_outlined), label: "Rotate"),
          BottomNavigationBarItem(
              icon: Icon(Icons.rotate_right_outlined), label: "Rotate"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_backup_restore), label: "Reset")
        ],
        currentIndex: 0,
        onTap: (position) {
          switch (position) {
            case 1:
              _editorKey.currentState.rotate(right: false);
              break;
            case 2:
              _editorKey.currentState.rotate(right: true);
              break;
            case 3:
              _editorKey.currentState.reset();
              break;
          }
          setState(() {});
        },
      ),
    );
  }

  var _isCropping = false;

  _body() {
    return ExtendedImage.memory(
      _bytes,
      fit: BoxFit.contain,
      mode: ExtendedImageMode.editor,
      extendedImageEditorKey: _editorKey,
      initEditorConfigHandler: (state) {
        return EditorConfig(
            maxScale: 8.0,
            cropRectPadding: EdgeInsets.all(20.0),
            hitTestSize: 20.0,
            cropAspectRatio: 1);
      },
    );
  }

  _upload() async {
    var bytes = await _crop();
    GetIt.instance<HttpManager>().Upload(bytes,
        query: {"type": "user"},
        token: GetIt.instance<AppConfig>().token, onSuccess: (data) {
      _isCropping = false;
      Chat chat = Chat.fromJson(data);
      if (chat.code == 200) {
        var p = Provider.of<UserInfoProvider>(context, listen: false);
        p.set(p.user..avatar_path = chat.msg);
        Fluttertoast.showToast(msg: "upload success! ヾ(≧▽≦*)o");
        Navigator.of(context).pop(chat.msg);
      }
    }, onError: (e) {
      _isCropping = false;
      Fluttertoast.showToast(msg: "upload failure! φ(゜▽゜*)♪");
      log(e);
    });
  }

  _crop() async {
    if (_isCropping) return;
    _isCropping = true;
    return Uint8List.fromList(kIsWeb
        ? await cropImageDataWithDartLibrary(state: _editorKey.currentState)
        : await cropImageDataWithNativeLibrary(state: _editorKey.currentState));
  }
}
