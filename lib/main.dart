
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(child: HomePage()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController webViewController;
  int _currentIndex = 0;
  
  final List<String> _urls = [
    'https://www.lavalsehotel.com',
    'http://www.president.go.kr/',
    'https://www.google.com',
    'https://www.naver.com',
    'https://en.m.wikipedia.org/'
  ];

  launchUrl(){
      this.webViewController.loadUrl(this._urls[_currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: _urls[_currentIndex],
        onWebViewCreated: (WebViewController webViewController) {
          this.webViewController = webViewController;
          _controller.complete(webViewController);
        },
        javascriptMode: JavascriptMode.unrestricted,
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items:[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Main')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_late),
                title: Text('Notice')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                title: Text('Book')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.developer_board),
                title: Text('Board')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.help_outline),
                title: Text('Inquery'),
            ),
          ]
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      launchUrl();
    });
  }
}
