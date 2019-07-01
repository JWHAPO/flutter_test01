import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  var _id = '';
  var _pw = '';

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
              onChanged: (_id) {
                this._id = _id;
              },
            ),
            TextField(
              enabled: true,
              maxLength: 20,
              obscureText: true,
              style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
              onChanged: (_pw){
                this._pw = _pw;
              },
            ),
            RaisedButton(
              child: Text('Login', style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),),
              onPressed: (){

                print('id:$_id , pw:$_pw');
              },
            )
          ],
        ),
        )
      ),
    );
  }
}
