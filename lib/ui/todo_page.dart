import 'package:flutter/material.dart';

import '../bloc/todo_provider.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  
  Widget _buildListTile(AsyncSnapshot snapshot, int index){
    var id = snapshot.data[index].id;
    var title = snapshot.data[index].title;
    bool completed = snapshot.data[index].completed;

    return ListTile(
      leading: Text('$id'),
      title: Text('$title'),
      subtitle: Text('completed ',
        style: TextStyle(color: completed?Colors.lightBlue : Colors.red),),
    );
  }
  
  @override
  Widget build(BuildContext context) {

    final todoBloc = TodoProvider.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Stream Builder width Bloc'),
            RaisedButton(
              color: Colors.lightBlue[200],
              child: Text('Load Data', style: TextStyle(color: Colors.white),),
              onPressed: (){
                todoBloc.getTodo();
              },
            ),
            Flexible(
              child: StreamBuilder(
                stream: todoBloc.results,
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return Text('No data');
                  }else{
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => _buildListTile(snapshot, index),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}