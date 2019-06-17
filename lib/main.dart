import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'data/Actions.dart';
import 'data/Urls.dart';
import 'splash_screen.dart';
import 'data/Texts.dart';
import 'package:flutter/services.dart';
import 'data/LoginUser.dart';
import 'common/MySharedPreferences.dart';
import 'model/Message.dart';

void main() => runApp(MyApp());

var routes = <String, WidgetBuilder>{
  '/main':(BuildContext context) => HomePage(Texts.app_bar_title)
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
  Completer<WebViewController> _controller = Completer<WebViewController> ();
  MySharedPreferences prefs = MySharedPreferences();
  WebViewController webViewController;
  int _currentIndex = 0;
  int _badgeCount = 0;
  String firebaseToken = "";
  bool visibilityBackButton = false;
  bool visibilityBadgeButton = false;

  final FirebaseMessaging _messaging = FirebaseMessaging();
  final List<Message> messages = [];
  static const platform = const MethodChannel('flutter.native/helper');

  Future<void> responseFromNativeCode() async {
    String response = '';
    try{
      final String result = await platform.invokeMethod('helloFromNativeCode');
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }

    setState(() {
      print(response);
    });

  }

  
  void _changedVisibility(bool visibility, String field){
    setState(() {

      switch (field) {
        case 'backButton':
          visibilityBackButton = visibility;
          break;
        case 'badgeButton':
          visibilityBadgeButton = visibility;
          break;
        default:
      }
    });
  }
  void _hideBackButton() async {
    await this.webViewController.canGoBack() ? _changedVisibility(true, 'backButton') : _changedVisibility(false, 'backButton');
  }

  void _hideBadgeButton() {
    print('_badgeCount$_badgeCount');
    _badgeCount>0 ? _changedVisibility(true, 'badgeButton') : _changedVisibility(false, 'badgeButton');
  }

  @override
  void initState() {
    super.initState();
    

    prefs.getBadgeCountForEvent().then( (badgeCount) async{
      _badgeCount = badgeCount;
      _hideBadgeButton();
    } );
    

    //권한을 설정
    _messaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _messaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Setting s registered: $settings');
    });

    //PlatformException 발생 시 flutter clean 하고 flutter packages get 한번 돌려봐라
    _messaging.getToken().then((token) async{
      print('firebase token:' + token);
      prefs.setFirebaseToken(token);
      firebaseToken = await prefs.getFirebaseToken();
    });

    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {

        _badgeCount += 1;
        
        setState(() {
          prefs.setBadgeCountForEvent(_badgeCount);
          _hideBadgeButton();
        });

        print(message);

        final notification = message['data'];
        final url = notification['url1'];
        print('onMessage $url');
      },
      onResume: (Map<String, dynamic> message) async {
        final notification = message['data'];
        final url = notification['url1'];
        print('onResume:$url');
      },
      onLaunch: (Map<String, dynamic> message) async {
        final notification = message['data'];
        final url = notification['url1'];
        print('onLaunch:$url');
      },
    );
  }

  Future<bool> _onBackPressed() {
    // NavigationControls(_controller.future).navigate(context, this.webViewController, goBack: true);
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(Texts.msg_exit_question),
              actions: <Widget>[
                FlatButton(
                  child: Text(Texts.no),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text(Texts.yes),
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
            leading: visibilityBackButton ? NavigationControls(_controller.future) : null,
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
            onPageFinished: (String url) {
              _hideBackButton();
            },
            gestureRecognizers: Set()
                ..add(
                Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer(),
                ),
            ),
            javascriptChannels: Set.from([
              sendFirebaseTokenToWeb(this.webViewController),
              loadUrlOnNewView(this.webViewController),
            ]),
          ),
          bottomNavigationBar: BottomNavigationBar(
              onTap: onTabTapped,
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.shifting,
              fixedColor: Colors.lightBlue,
              unselectedItemColor: Colors.lightBlue,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), title: Text(Texts.tab1)),
                BottomNavigationBarItem(
                    icon: Icon(Icons.assignment_late), title: Text(Texts.tab2)),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today), title: Text(Texts.tab3)),
                BottomNavigationBarItem(
                    icon: Stack(
                      children: <Widget>[
                        Icon(Icons.developer_board),
                        Positioned(
                          right: 0,
                          child: visibilityBadgeButton ? Container(
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 14,
                              minHeight: 14
                            ),
                            child: Text(
                              '$_badgeCount',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ) : Container(),
                        )
                      ],
                    ),
                    title: Text(Texts.tab4)
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.help_outline),
                  title: Text(Texts.tab5),
                ),
              ]),
        ));
  }

  void onTabTapped(int index) {
    setState(() { 
      _currentIndex = index;
      this.webViewController.loadUrl(Urls.urls[_currentIndex]);

      if(_currentIndex==3){
        _badgeCount = 0;
        prefs.setBadgeCountForEvent(_badgeCount);
        _hideBadgeButton();
      }
    });
  }

  void choiceAction(String choice) async {
    final Map<String, String> headers = <String, String>{
      'cookie': await prefs.getCookie()
    };

    if (choice == Actions.Settings) {
      this.webViewController.loadUrl('https://www.daum.net',headers: headers);
    } else if (choice == Actions.Subscribe) {
      this.webViewController.loadUrl('https://www.android.com');
    }
  }

  JavascriptChannel sendFirebaseTokenToWeb(WebViewController wvc){
    return JavascriptChannel(
      name: 'sendFirebaseTokenToWeb',
      onMessageReceived: (JavascriptMessage message){ // userId, cookie
        Map loginUserMap = jsonDecode(message.message);
        var loginUser = new LoginUser.fromJson(loginUserMap);

        print(message.message);

        print('LoginUser - id :, ${loginUser.id}');
        print('LoginUser - token :, ${loginUser.token}');
        print('LoginUser - cookie :, ${loginUser.cookie}');

        prefs.setCookie(loginUser.cookie);

        loginUser.token = firebaseToken;

        String json = jsonEncode(loginUser);
        String sendJavascript = "javascript:saveFirebaseTokenInUser('$json');";
        print(sendJavascript);
        
        wvc.evaluateJavascript(sendJavascript); // userId, token
      }
    );
  }

  JavascriptChannel loadUrlOnNewView(WebViewController wvc){
    return JavascriptChannel(
      name: 'loadUrlOnNewView',
      onMessageReceived: (JavascriptMessage message){
        print(message.message);
        wvc.evaluateJavascript("javascript:saveFirebaseTokenInUser();");
      }
    );
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
