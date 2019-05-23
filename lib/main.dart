
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(child: HomePage('La Valse')),
      debugShowCheckedModeBanner: false,
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
  WebViewController webViewController;
  int _currentIndex = 0;

  final FirebaseMessaging _messaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    //PlatformException 발생 시 flutter clean 하고 flutter packages get 한번 돌려봐라
    _messaging.getToken().then((token){
      print('firebase token:'+token);
    });
  }

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
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          NavigationControls(_controller.future),
        ],
      ),
      body: WebView(
        initialUrl: _urls[_currentIndex],
        onWebViewCreated: (WebViewController webViewController) {
          this.webViewController = webViewController;
          _controller.complete(webViewController);
        },
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request){
          if(request.url.startsWith('https://www.naver.')){
            print('LaValse');
            return NavigationDecision.prevent;
          }

          print('gogo');
          return NavigationDecision.navigate;

        },
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

class NavigationControls extends StatelessWidget {
  final Future<WebViewController> _webViewcontrollerFuture;

  const NavigationControls(this._webViewcontrollerFuture) : assert(_webViewcontrollerFuture != null);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewcontrollerFuture,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot){
        final  bool webViewReady = snapshot.connectionState ==ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady?null:()=>navigate(context, controller, goBack: true),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady?null:()=>navigate(context, controller, goBack: false),
            )
          ],
        );
      },
    );
  }

  navigate(BuildContext context, WebViewController controller, {bool goBack: false}) async{
    bool canNavigate = goBack ? await controller.canGoBack() : await controller.canGoForward();
    if(canNavigate) {
      goBack ? controller.goBack() : controller.goForward();
    }else{
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text("No ${goBack ? 'back' : 'foward'} history item")),
      );
    }
  }

}

