part of 'todo_model.dart';

//예선 작성//
Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
  json['userId'] as int,
  json['id'] as int,
  json['title'] as String,
  json['completed'] as bool,
);

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
  'userId': instance.userId,
  'id': instance.id,
  'title': instance.title,
  'completed': instance.completed,
};

All _$AllTodosFromJson(Map<String, dynamic> json) => All(
  (json['todos'] as List<dynamic>)
      .map((e) => Todo.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AllTodosToJson(All instance) => <String, dynamic>{
  'todos': instance.todo,
};
