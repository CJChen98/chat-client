import 'package:flutter/material.dart';

class BigImagePage extends StatelessWidget {
  static String routName = "/image";
  String url;
  String tag;
  List<String> args;

  BigImagePage({this.args}) {
    url = args.first;
    tag = args.last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Hero(
            tag: tag,
            child: Image.network(
              url,
            ),
          ),
        ),
      ),
    );
  }
}
