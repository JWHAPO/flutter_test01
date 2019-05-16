// Flutter code sample for material.AppBar.actions.1

// This sample shows adding an action to an [AppBar] that opens a shopping cart.

import 'package:flutter/material.dart';
import 'placeholder_widget.dart';

//void main() => runApp(MyApp());

/// This Widget is the main application widget.
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//        title: "FLUTTER DEMO",
//        theme: ThemeData(primarySwatch: Colors.blue),
//        home: HelloPage('Hello', 'Hapo'));
//  }
//}

class HelloPage extends StatefulWidget {
  final String title;
  final String contents;

  HelloPage(this.title, this.contents);

  @override
  _HelloPageState createState() => _HelloPageState();
}

class _HelloPageState extends State<HelloPage> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    PlaceholderWidget(Colors.white),
    PlaceholderWidget(Colors.deepOrange),
    PlaceholderWidget(Colors.green)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items:[
            BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Text('Home')
            ),
            BottomNavigationBarItem(
                icon: new Icon(Icons.mail),
                title: new Text('Messages')
            ),
            BottomNavigationBarItem(
                icon: new Icon(Icons.person),
                title: new Text('Profile')
            ),
          ]
      ),
    );
  }

  void onTabTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }

}
