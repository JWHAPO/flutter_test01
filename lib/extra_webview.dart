import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExtraWebView extends StatefulWidget {
  final String url;

  ExtraWebView({Key key, @required this.url}) : super(key: key);

  @override
  _ExtraWebViewState createState() => _ExtraWebViewState();
}

class _ExtraWebViewState extends State<ExtraWebView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 10,
                child: WebView(
                  initialUrl: widget.url,
                  onWebViewCreated: (WebViewController webViewController) {},
                  javascriptMode: JavascriptMode.unrestricted,
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url.startsWith('###')) {
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  },
                  onPageFinished: (String url) {},
                  gestureRecognizers: Set()
                    ..add(
                      Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer(),
                      ),
                    ),
                ),
              ),
              Flexible(
                  flex: 1,
                  child: Container(
                      color: Colors.white30,
                      padding: EdgeInsets.all(10.0),
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context,"1");
                        },
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
