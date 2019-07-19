import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/todo.dart';

class API {
  final http.Client _client = http.Client();

  static const String _url = "https://jsonplaceholder.typicode.com/todos";

  Future<List<Todo>> getTodo() async{
    List<Todo> list = [];

    await _client
        .get(Uri.parse(_url))
        .then((res) => res.body)
        .then(json.decode)
        .then((todos) =>
          todos.forEach((todo) => list.add(Todo.fromJson(todo)))  
        );

      return list;

  }


}