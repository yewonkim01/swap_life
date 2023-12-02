import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:swap_life/shared/shared.dart';

//예선 작성//
class HttpServices implements Services {
  Future<List<Todo>> getTodo(int user) async {
    // TODO: implement getTodos
    throw UnimplementedError('Implement here');
  }

  @override
  Future<bool> addTodo(Todo todo) {
    // TODO: implement addTodo
    throw UnimplementedError('Implement here');
  }

  @override
  Future<bool> updateTodo(Todo todo) async {
    // TODO: implement addTodo
    throw UnimplementedError('Implement here');
  }
}
