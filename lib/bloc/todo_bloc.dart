import 'dart:async';
import '../model/todo.dart';
import '../repository/api.dart';

class TodoBloc{

  final API api;

  StreamController<List<Todo>> ctrl = StreamController();

  Stream<List<Todo>> get results => ctrl.stream;

  TodoBloc(this.api);

  void dispose(){
    ctrl.close();
  }

  void getTodo(){
    api.getTodo().then((todos){
      ctrl.add(todos);
    });
  }


}