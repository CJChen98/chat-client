import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/models/message.dart';
import 'package:get_it/get_it.dart';

class BubbleWidget extends StatelessWidget {
  Message message;
  AppConfig appConfig = GetIt.instance<AppConfig>();
  double _width;

  BubbleWidget(this.message);

  bool _isMyMessage;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _isMyMessage = message.user_id == appConfig.currentUserID;
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        // verticalDirection: VerticalDirection.up,
        mainAxisAlignment:
            _isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: _buildRow(),
      ),
    );
  }

  _buildRow() {
    var row = <Widget>[_bubbleColumn()];
    return _isMyMessage ? row : row.reversed.toList();
  }

  _bubbleColumn() {
    return Column(
      crossAxisAlignment:
          _isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          message.username,
          style: TextStyle(fontSize: 12),
        ),
        _bubbleContainer()
      ],
    );
  }

  _bubbleContainer() {
    var big = Radius.circular(15);
    var small = Radius.circular(5);
    var sendRadius = BorderRadius.only(
        topLeft: big, topRight: small, bottomLeft: big, bottomRight: big);
    var receiveRadius = BorderRadius.only(
        topLeft: small, topRight: big, bottomLeft: big, bottomRight: big);

    return Container(
      decoration: BoxDecoration(
          color: _isMyMessage ? Colors.blue : Colors.blueGrey[200],
          boxShadow: [
            BoxShadow(blurRadius: 4, spreadRadius: 0.1, color: Colors.grey)
          ],
          borderRadius: _isMyMessage ? sendRadius : receiveRadius),
      padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
      child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: (_width / 5) * 3),
          child: Text(
            _convertStringToRichText(),
            softWrap: true,
          )),
    );
  }

  _convertStringToRichText() {
    return message.content;
  }
}
