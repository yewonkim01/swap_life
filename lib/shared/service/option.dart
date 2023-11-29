import '../todo_model.dart';

abstract class Services {
  Future<List<Todo>> getTodo(int user);

  Future<bool> updateTodo(Todo todo);

  Future<bool> addTodo(Todo todo);
}