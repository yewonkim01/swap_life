import 'dart:async';

import 'service/option.dart';
import 'todo_model.dart';

class TodoController {
  final Services services;
  List<Todo>? todo;
  var counter = CompletedTodoCounter();

  StreamController<bool> onSyncController = StreamController();

  Stream<bool> get onSync => onSyncController.stream;

  TodoController(this.services);

  Future<List<Todo>> fetchTodo() async {
    throw UnimplementedError('Implement here');
  }

  Future<bool> updateTodo(Todo todo, bool isCompleted) async {
    throw UnimplementedError('Implement here');
  }

  int getCompletedTodo() {
    throw UnimplementedError('Implement here');
  }
}

class CompletedTodoCounter {
  int completed = 0;

  void increaseCounter() => completed++;

  void decreaseCounter() => completed--;

  void resetCounter() => completed = 0;
}
