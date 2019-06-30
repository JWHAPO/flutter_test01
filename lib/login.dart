import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

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
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              enabled: true,
              maxLength: 20,
              style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
            ),
            TextField(
              enabled: true,
              maxLength: 20,
              obscureText: true,
              style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
            ),
            RaisedButton(
              child: Text('Login', style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),),
              onPressed: (){

              },
            )
          ],
        ),
        )
      ),
    );
  }
}
