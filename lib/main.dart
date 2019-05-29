import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'data/Actions.dart';
import 'data/Urls.dart';
import 'splash_screen.dart';

void main() => runApp(MyApp());

var routes = <String, WidgetBuilder>{
  '/main':(BuildContext context) => HomePage('La Valse')
};

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(), // 앱이 실행되면 로딩화면을 맨 처음으로 띄운다.
      debugShowCheckedModeBanner: false,
      routes: routes,
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

    //권한을 설정
    _messaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _messaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Setting s registered: $settings');
    });

    //PlatformException 발생 시 flutter clean 하고 flutter packages get 한번 돌려봐라
    _messaging.getToken().then((token) {
      print('firebase token:' + token);
    });

    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onResume $message');
        setState(() {});
      },
      onResume: (Map<String, dynamic> message) async {
        final notification = message['data'];
        final url = notification['url'];
        print('onResume:$url');
      },
      onLaunch: (Map<String, dynamic> message) async {
        final notification = message['data'];
        final url = notification['url'];
        print('onLaunch:$url');
      },
    );
  }


  launchUrl() {
    this.webViewController.loadUrl(Urls.urls[_currentIndex]);
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you want to exit?"),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () => Navigator.pop(context, true),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: <Widget>[
              NavigationControls(_controller.future),
              PopupMenuButton<String>(
                onSelected: choiceAction,
                itemBuilder: (BuildContext context) {
                  return Actions.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      child: Text(choice),
                      value: choice,
                    );
                  }).toList();
                },
              )
            ],
          ),
          body: WebView(
            initialUrl: Urls.urls[_currentIndex],
            onWebViewCreated: (WebViewController webViewController) {
              this.webViewController = webViewController;
              _controller.complete(webViewController);
            },
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('###')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
              onTap: onTabTapped,
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), title: Text('Main')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.assignment_late), title: Text('Notice')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today), title: Text('Book')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.developer_board), title: Text('Board')),
                BottomNavigationBarItem(
                  icon: Icon(Icons.help_outline),
                  title: Text('Inquery'),
                ),
              ]),
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      launchUrl();
    });
  }

  void choiceAction(String choice) {
    if (choice == Actions.Settings) {
      this.webViewController.loadUrl('https://www.daum.net');
    } else if (choice == Actions.Subscribe) {
      this.webViewController.loadUrl('https://www.android.com');
    }
  }
}

class NavigationControls extends StatelessWidget {
  final Future<WebViewController> _webViewcontrollerFuture;

  const NavigationControls(this._webViewcontrollerFuture)
      : assert(_webViewcontrollerFuture != null);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewcontrollerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () => navigate(context, controller, goBack: true),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () => navigate(context, controller, goBack: false),
            )
          ],
        );
      },
    );
  }

  navigate(BuildContext context, WebViewController controller,
      {bool goBack: false}) async {
    bool canNavigate =
        goBack ? await controller.canGoBack() : await controller.canGoForward();
    if (canNavigate) {
      goBack ? controller.goBack() : controller.goForward();
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
            content: Text("No ${goBack ? 'back' : 'foward'} history item")),
      );
    }
  }
}
