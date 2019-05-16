// Flutter code sample for material.AppBar.actions.1

// This sample shows adding an action to an [AppBar] that opens a shopping cart.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planets',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[GradientAppBar('trevar')],
      ),
    );
  }
}

class GradientAppBar extends StatelessWidget {
  final String title;
  final double barHeight = 66.0;

  GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      height: barHeight,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [const Color(0xFF3366FF), const Color(0xFF00CCFF)],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.5, 0.0),
              stops: [0.0, 0.5],
              tileMode: TileMode.clamp)),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 36.0),
        ),
      ),
    );
  }
}
