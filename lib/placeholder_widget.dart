import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget{
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Row(
            children: <Widget>[
              Text('aaaa'),
              Icon(Icons.accessibility,size: 100.0,),
              MaterialButton(onPressed: null,
                height: 120.0,
              )
            ],
          ),
        ),
    );
  }
}