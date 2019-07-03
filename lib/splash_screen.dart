import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () => Navigator.pushReplacementNamed(context, '/main')); // 2초 뒤에 HomePage로 이동
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(//그라데이션이 들어간 Container를 생성.
            decoration: BoxDecoration(
              color: Color(0xffd38213),
              gradient: LinearGradient(
                colors: [Color(0xffffe1b7), Color(0xffd38213)],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('HAPO',
              style: TextStyle(color: Colors.white,
              fontSize: 28.0,
              fontFamily: 'Poppins'),),
              Text('Jun Bomi',
              style: TextStyle(color: Colors.white,
              fontSize: 42.0,
              fontFamily: 'Poppins'),)
            ],
          )
        ],
      ),
    );
  }
}