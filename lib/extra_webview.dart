import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

class ExtraWebView extends StatelessWidget {

  final String url;
  ExtraWebView({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: WebView(
            initialUrl: url,
            onWebViewCreated: (WebViewController webViewController) {
            },
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (String url) async {

            },
            gestureRecognizers: Set()
                ..add(
                Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer(),
                ),
            ),
          ),
      ),
    );
  }
}