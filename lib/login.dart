import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin{

  var _opacity = 0.0;
  var _id = '';
  var _pw = '';
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1
    )..addListener((){
      setState(() {
      });
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTabDown(TapDownDetails details){
    _controller.forward();
  }

  void _onTabUp(TapUpDetails details){
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {

    _scale = 1- _controller.value;

    return MaterialApp(
      home: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () { },
            tooltip: 'Increment',
            child: Icon(Icons.add),
            elevation: 2.0,
          ),
        body: SafeArea(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Draggable(
              child: Text('Dragable',style: TextStyle(color: Colors.blue),),
              feedback: Text('Dragable',style: TextStyle(color: Colors.red),),
              childWhenDragging: Text('Dragable',style: TextStyle(color: Colors.green),),
            ),
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
                setState(() {
                 _opacity = _opacity==0.0?1.0:0.0; 
                });
              },
            ),
            GestureDetector(
              onTapDown: _onTabDown,
              onTapUp: _onTabUp,
              child: Transform.scale(scale: _scale,child: _animatedButtonUI,),
            ),
            Wrap(
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
            ),AnimatedOpacity(
              duration: Duration(seconds: 1),
              opacity: _opacity,
              
              child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Align(
                alignment: Alignment.center,
                heightFactor: 0.5,
                widthFactor: 0.5,
                child: Image.asset('assets/image/potato.jpg',alignment: Alignment.center,fit: BoxFit.contain,),
              ),
            ),
            )
          ],
        ),
        )
      ),
    );
  }

  Widget get _animatedButtonUI => Container(
    height: 100,
    width: 250,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      boxShadow: [ BoxShadow(
        color: Colors.grey,
        blurRadius: 20.0
      ) ],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFA7BFE8),
          Color(0xFF6190E8),
        ],
      ),
    ),
    child: Center(
      child: Text('Tab', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.white),),
    ),
  );

}
