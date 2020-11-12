import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectIndex = 0;
  final List<Widget> _widgetList = <Widget>[
    // _ConversationListPage(),
    // _MinePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Chat"),
      ),
      body: _widgetList[_selectIndex],
      floatingActionButton: _selectIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                // _createConversationDialog(context);
              },
              child: Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Message"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Mine"),
        ],
        currentIndex: _selectIndex,
        onTap: (position) {
          setState(() {});
        },
      ),
    );
  }
}
