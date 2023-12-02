import 'dart:async';

import 'service/option.dart';
import 'todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



//예선 작성//
class TodoController {
  final Services services;
  List<Todo>? todo;
  var counter = CompletedTodoCounter();

  StreamController<bool> onSyncController = StreamController();

  Stream<bool> get onSync => onSyncController.stream;

  TodoController(this.services);

  Future<List<Todo>> fetchTodo() async {
    try {
      // 예제: Firebase Firestore에서 'todos' 컬렉션의 데이터 가져오기
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('todos').get();

      // 가져온 데이터를 Todo 객체로 변환
      List<Todo> todos = querySnapshot.docs
          .map((doc) => Todo.fromJson(doc.data()!))
          .toList();

      // 가져온 Todo 리스트를 클래스 변수에 저장
      todo = todos;

      return todos;
    } catch (e) {
      print('Error fetching todos: $e');
      throw e;
    }
  }

  Future<bool> updateTodo(Todo todo, bool isCompleted) async {
    try {
      // 예제: Firebase Firestore에서 'todos' 컬렉션의 특정 문서 업데이트
      await FirebaseFirestore.instance
          .collection('todos')
          .doc(todo.id.toString())
          .update({'isCompleted': isCompleted});

      // 업데이트 후에는 동기화 이벤트를 발생시킴
      onSyncController.add(true);

      return true;
    } catch (e) {
      print('Error updating todo: $e');
      throw e;
    }
  }

  int getCompletedTodo() {
    try {
      // 예제: 완료된 todo 수를 계산
      int completedCount = todo?.where((t) => t.completed)?.length ?? 0;

      return completedCount;
    } catch (e) {
      // 오류 처리
      print('Error getting completed todo count: $e');
      throw e;
    }
  }
}

//예선 작성//
class CompletedTodoCounter {
  int completed = 0;

  void increaseCounter() => completed++;

  void decreaseCounter() => completed--;

  void resetCounter() => completed = 0;
}
