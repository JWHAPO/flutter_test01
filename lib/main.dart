// Flutter code sample for material.AppBar.actions.1

// This sample shows adding an action to an [AppBar] that opens a shopping cart.

import 'package:flutter/material.dart';
import 'placeholder_widget.dart';
import 'webview_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage('Trevar'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  HomePage(this.title);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  int _currentIndex = 0;
  final List<Widget> _children = [
    PlaceholderWidget(Colors.white),
    TestWebView(),
    PlaceholderWidget(Colors.green)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title, style: TextStyle(fontSize: 20),),
                    actions: <Widget>[
                      NavigationControls(_controller.future)
                    ],),
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


//class GradientAppBar extends StatelessWidget {
//  final String title;
//  final double barHeight = 66.0;
//
//  GradientAppBar(this.title);
//
//  @override
//  Widget build(BuildContext context) {
//    final double statusBarHeight = MediaQuery.of(context).padding.top;
//
//    return Container(
//      padding: EdgeInsets.only(top: statusBarHeight, bottom: statusBarHeight),
//      height: barHeight,
//      decoration: BoxDecoration(
//          gradient: LinearGradient(
//              colors: [const Color(0xFF3366FF), const Color(0xFF00CCFF)],
//              begin: const FractionalOffset(0.0, 0.0),
//              end: const FractionalOffset(0.5, 0.0),
//              stops: [0.0, 0.5],
//              tileMode: TileMode.clamp)),
//      child: Center(
//        child: Text(
//          title,
//          style: const TextStyle(
//              color: Colors.white,
//              fontFamily: 'Poppins',
//              fontWeight: FontWeight.w600,
//              fontSize: 36.0),
//        ),
//      ),
//    );
//  }
//}
