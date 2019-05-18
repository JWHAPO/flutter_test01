import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class TestWebView extends StatefulWidget {
  final String url;

  TestWebView(this.url);

  @override
  _TestWebViewState createState() => _TestWebViewState(url);
}

class _TestWebViewState extends State<TestWebView> {
  final String url;
  Completer<WebViewController> _controller = Completer<WebViewController>();

  _TestWebViewState(this.url);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: WebView(
        initialUrl: this.url,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
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
