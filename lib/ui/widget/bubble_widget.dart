import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/config/app_config.dart';
import 'package:flutter_web/data/conversations_provider.dart';
import 'package:flutter_web/models/chat.dart';
import 'package:flutter_web/models/message.dart';
import 'package:flutter_web/network/http_manager.dart';
import 'package:flutter_web/ui/big_image_page.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../user_info_page.dart';

class BubbleWidget extends StatefulWidget {
  Message message;
  String tag;

  BubbleWidget(this.message, this.tag);

  @override
  State<StatefulWidget> createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget> {
  AppConfig _appConfig = GetIt.instance<AppConfig>();
  double _width;
  bool _isMyMessage;

  // String _avatarPath;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  _fetchData() async {
    GetIt.instance<HttpManager>().GET("/fetch/",
        query: {"type": "user", "id": widget.message.user_id},
        token: _appConfig.token, onSuccess: (data) {
      Chat chat = Chat.fromJson(data);
      if (chat.code == 2002) {
        Provider.of<ConversationsProvider>(context, listen: false)
            .updateMessage(
                widget.message.receiver_id,
                widget.message
                  ..user_avatar =
                      _appConfig.apiHost + chat.data.users.first.avatar_path);
      }
    }, onError: (e) {
      log(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _isMyMessage = widget.message.user_id == _appConfig.currentUserID;
    return Container(
      padding: EdgeInsets.all(4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            _isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: _buildRow(),
      ),
    );
  }

  _buildRow() {
    var row = <Widget>[_bubbleColumn(), _avatar()];
    return _isMyMessage ? row : row.reversed.toList();
  }

  _avatar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(UserInfoPage.routName,
              arguments: [widget.message.user_id, widget.tag]);
        },
        child: Hero(
          tag: widget.tag,
          child: CircleAvatar(
            radius: 22,
            backgroundImage: widget.message.user_avatar.isEmpty
                ? AssetImage('assets/images/empty.png')
                : CachedNetworkImageProvider(widget.message.user_avatar),
          ),
        ),
      ),
    );
  }

  _bubbleColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          _isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.message.username,
          style: TextStyle(fontSize: 13),
        ),
        _bubbleContainer()
      ],
    );
  }

  _bubbleContainer() {
    var big = Radius.circular(13);
    var small = Radius.circular(5);
    var sendRadius = BorderRadius.only(
        topLeft: big, topRight: small, bottomLeft: big, bottomRight: big);
    var receiveRadius = BorderRadius.only(
        topLeft: small, topRight: big, bottomLeft: big, bottomRight: big);

    return Container(
      margin: EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
          color: _isMyMessage ? Colors.blue : Colors.blueGrey[200],
          boxShadow: [
            BoxShadow(blurRadius: 4, spreadRadius: 0.1, color: Colors.grey)
          ],
          borderRadius: _isMyMessage ? sendRadius : receiveRadius),
      padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
      child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: (_width / 5) * 3),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _messageAnalysis())),
    );
  }

  _messageAnalysis() {
    var widgets = <Widget>[];
    if (widget.message.content.isNotEmpty) {
      widgets.add(Text(
        _convertStringToRichText(),
        softWrap: true,
        style: TextStyle(fontSize: 15),
        textAlign: TextAlign.start,
      ));
    }
    if (widget.message.image_url.isNotEmpty) {
      widgets.add(Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(BigImagePage.routName, arguments: [
              _appConfig.apiHost + widget.message.image_url,
              "img-" + widget.tag
            ]);
          },
          child: Hero(
            tag: "img-" + widget.tag,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: _appConfig.apiHost + widget.message.image_url,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      ),
                )),
          ),
        ),
      ));
    }
    return widgets;
  }

  _convertStringToRichText() {
    return widget.message.content;
  }
}
