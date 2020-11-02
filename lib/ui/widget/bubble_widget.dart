import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/models/message.dart';
import 'package:flutter_web/utils/constant.dart';
import 'package:flutter_web/utils/size_config.dart';
import 'package:get_it/get_it.dart';

class BubbleWidget extends StatefulWidget {
  Message message;
  AppConfig appConfig = GetIt.instance<AppConfig>();
  BubbleWidget(this.message);

  @override
  _BubbleWidgetState createState() => _BubbleWidgetState(message);
}

class _BubbleWidgetState extends State<BubbleWidget> {
  Message message;

  _BubbleWidgetState(this.message);

  bool _msgType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _msgType = message.user_id == widget.appConfig.CurrentUserID;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.dp),
      child: Row(
        // verticalDirection: VerticalDirection.up,
        mainAxisAlignment:
            _msgType ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: _buildRow(),
      ),
    );
  }

  _buildRow() {
    var row = <Widget>[Icon(Icons.adb), _bubbleContainer()];
    if (_msgType) {
      return row;
    } else {
      return row.reversed.toList();
    }
  }

  _bubbleContainer() {
    var sendRadius = BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(5),
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20));
    var receiveRadius = BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20));
    return Container(
      decoration: BoxDecoration(
          color: _msgType ? Colors.blue : Colors.blueGrey[200],
          boxShadow: [
            BoxShadow(blurRadius: 4, spreadRadius: 0.1, color: Colors.grey)
          ],
          borderRadius: _msgType ? sendRadius : receiveRadius),
      padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth / 5 * 3),
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
