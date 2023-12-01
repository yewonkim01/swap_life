import '../todo_model.dart';

//예선 작성//
abstract class Services {
  Future<List<Todo>> getTodo(int user);

  Future<bool> updateTodo(Todo todo);

  Future<bool> addTodo(Todo todo);
}