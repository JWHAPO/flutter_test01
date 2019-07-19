import 'package:flutter/material.dart';
import 'todo_bloc.dart';
import '../repository/api.dart';

class TodoProvider extends InheritedWidget{
  final TodoBloc todoBloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static TodoBloc of(BuildContext context) =>
    (context.inheritFromWidgetOfExactType(TodoProvider) as TodoProvider).todoBloc;

  TodoProvider({Key key, TodoBloc todoBloc, Widget child})
    : this.todoBloc = todoBloc ?? TodoBloc(API()),
      super(child: child, key: key);
}