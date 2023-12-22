import 'package:flutter/material.dart';
import 'package:swap_life/TodoScreen.dart';
import 'package:swap_life/friends/friendList.dart';
import 'dart:core';

// 여기에 friend 창 구현 !!!
class FriendPage extends StatefulWidget {
  final List<Map<String, dynamic>>? friendChecklist;
  FriendPage({ required this.friendChecklist});
  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.friendChecklist?.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Checkbox(
              activeColor: Colors.white,
              checkColor: Colors.deepPurple,
              value: todoList[index].isCompleted,
              onChanged: (value) {
                // checkBoxa상태 변경을 위한 bool 함수
                toggleTodoItem(index);
                },
            ),
          );
          },
      )
    );
  }
  void toggleTodoItem(int index) {
    setState(() {
      todoList[index].isCompleted = !todoList[index].isCompleted;
    });
  }
}