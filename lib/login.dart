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
            RichText(text: TextSpan(
             style: DefaultTextStyle.of(context).style,
             children: <TextSpan>[
               TextSpan(text: 'It''s ', style: TextStyle(color: Colors.blue, fontSize: 6.0)),
               TextSpan(text: 'Login', style: TextStyle(color: Colors.blueAccent, fontSize: 10.0)),
               TextSpan(text: 'Page.', style: TextStyle(color: Colors.blue, fontSize: 6.0)),
             ]
          )),
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
            ),Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              children: <Widget>[
                Container(
                  child: Chip(
                    label: Text('Hamilton',style: TextStyle(color: Colors.white),),
                    backgroundColor: Colors.deepPurpleAccent,
                    elevation: 4,
                    shadowColor: Colors.grey[50],
                    padding: EdgeInsets.all(4),
                  ),
                  margin: EdgeInsets.only(left: 12, right: 12,top: 2,bottom: 2),
                ),
                Chip(
                  avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: Text('ML')),
                  label: Text('Lafayette'),
                ),
                Chip(
                  avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: Text('HM')),
                  label: Text('Mulligan'),
                ),
                Chip(
                  avatar: CircleAvatar(backgroundColor: Colors.blue.shade900, child: Text('JL')),
                  label: Text('Laurens'),
                ),
              ],
            ),ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Align(
                alignment: Alignment.center,
                heightFactor: 0.5,
                widthFactor: 0.5,
                child: Image.asset('assets/image/potato.jpg',alignment: Alignment.center,fit: BoxFit.contain,),
              ),
            )
          ],
        ),
        )
      ),
    );
  }
}
