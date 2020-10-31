import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web/model/entity.dart';
import 'package:flutter_web/ui/widget/BubbleWidget.dart';
import 'package:flutter_web/utils/Constant.dart';
import 'package:flutter_web/utils/SizeConfig.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("chat~")),
      body: _main(),
    );
  }

  _bottomInputBar() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 10, spreadRadius: 0.1, color: Colors.grey)
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.dp), topRight: Radius.circular(8.dp))),
      child: Padding(
        padding:
            EdgeInsets.only(left: 8.dp, right: 8.dp, top: 2.dp, bottom: 2.dp),
        child: Column(
          children: <Widget>[_inputToolBar(), _inputTextField()],
        ),
      ),
    );
  }

  _inputToolBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.mic, color: Colors.blue),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.image, color: Colors.blue),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.emoji_emotions, color: Colors.blue),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.code, color: Colors.blue),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.add_circle, color: Colors.blue),
        ),
      ],
    );
  }

  var _inputController = TextEditingController();

  _inputTextField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
            child: TextField(
          decoration: InputDecoration(hintText: "Say something ..."),
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 15,
          controller: _inputController,
        )),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.send),
        )
      ],
    );
  }

  List<Message> _messages = List<Message>();

  _messageList() {
    return Expanded(
        child: ListView.builder(
      itemCount:
          _messages == null ?? _messages.length == 0 ? 0 : _messages.length,
      itemBuilder: (context, index) {
        return BubbleWidget(_messages[index]);
      },
    ));
  }

  _fetchData() async {
    while (_messages.length < 2) {
      var message = Message()
        ..content = _messages.length % 2 == 0 ? Constant.text1 : Constant.text2;
      setState(() {
        _messages.add(message);
      });
      Future.delayed(Duration(seconds: 30), () => "fetch data");
    }
    _messages.add(Message()
      ..content = Constant.text2
      ..userId = Constant.id);
    while (_messages.length < 2) {
      var message = Message()
        ..content = _messages.length % 2 == 0 ? Constant.text1 : Constant.text2;
      setState(() {
        _messages.add(message);
      });
      Future.delayed(Duration(seconds: 30), () => "fetch data");
    }
  }

  _main() {
    // var channel = IOWebSocketChannel.connect("")
    return Column(
      children: <Widget>[
        _messageList(),
        _bottomInputBar(),
      ],
    );
  }
}