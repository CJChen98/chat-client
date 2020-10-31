import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/model/entity.dart';
import 'package:flutter_web/utils/Constant.dart';
import 'package:flutter_web/utils/SizeConfig.dart';

class BubbleWidget extends StatefulWidget {
  Message message;

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
    _msgType = message.userId == Constant.id;
    print(_msgType);
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
        topLeft: Radius.circular(20.dp),
        topRight: Radius.circular(5.dp),
        bottomLeft: Radius.circular(20.dp),
        bottomRight: Radius.circular(20.dp));
    var receiveRadius = BorderRadius.only(
        topLeft: Radius.circular(5.dp),
        topRight: Radius.circular(20.dp),
        bottomLeft: Radius.circular(20.dp),
        bottomRight: Radius.circular(20.dp));
    return Container(
      decoration: BoxDecoration(
          color: _msgType ? Colors.blue : Colors.blueGrey[200],
          boxShadow: [
            BoxShadow(
                blurRadius: 4, spreadRadius: 0.1, color: Colors.grey)
          ],
          borderRadius: _msgType ? sendRadius : receiveRadius),
      padding:
          EdgeInsets.only(left: 8.dp, right: 8.dp, top: 4.dp, bottom: 4.dp),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth / 4 * 3),
        child: Text.rich(TextSpan(text: _convertStringToRichText())),
      ),
    );
  }

  _convertStringToRichText() {
    return message.content;
  }
}
