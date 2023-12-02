//예선 작성//
import 'package:json_annotation/json_annotation.dart';

part 'model_json.dart';

@JsonSerializable()
class Todo {
  final int userId;
  final int id;
  final String title;
  bool completed;

  Todo(this.userId, this.id, this.title, this.completed);

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}

@JsonSerializable()
class All {
  final List<Todo> todo;

  All(this.todo);

  factory All.fromJson(List<dynamic> json) {
    List<Todo> todos = [];
    todos = json.map((i) => Todo.fromJson(i)).toList();
    return All(todos);
  }

  factory All.fromSnapshot(dynamic s) {
    List<Todo> todos = s.documents.map((dynamic ds) {
      return Todo.fromJson(ds.data);
    }).toList();
    return All(todos);
  }

  Map<String, dynamic> toJson() => _$AllTodosToJson(this);
}
