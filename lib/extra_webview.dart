import 'package:flutter/material.dart';


class ExtraWebView extends StatelessWidget {

  final String url;
  ExtraWebView({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Text('TEST'),
        ),
      ),
    );
  }
}