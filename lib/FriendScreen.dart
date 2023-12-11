import 'package:flutter/material.dart';
import 'package:swap_life/TodoScreen.dart';
import 'package:swap_life/friends/friendList.dart';
import 'package:swap_life/shared/todo_controller.dart';
import 'dart:core';

// 여기에 friend 창 구현 !!!

class FriendPage extends StatefulWidget {
  final TodoController controller;
  FriendPage({required this.controller});
  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 10),
          FriendList(widget.controller, context),
          //친구 list 없을 땐, sizebox랑 Text 삼항연산자로 띄우기
          SizedBox(height: 250),
          Text( "Friend's List", style: TextStyle(color: Colors.grey,fontStyle: FontStyle.italic),),
          Expanded(
              child: ListView.builder(
                itemCount: todoList.length,
                  itemBuilder: (context, index) {
                  return ListTile(
                    leading: Checkbox(
                      activeColor: Colors.white,
                      checkColor: Colors.deepPurple,
                      value: todoList[index].isCompleted,
                      onChanged: (value) {
                        // checkBox상태 변경을 위한 bool 함수
                        toggleTodoItem(index);
                      },
                    ),
                  );
                  },
              )
          ),
        ],
      ),
    );
  }
  void addTodoItem(String title, String mbti) {
    setState(() {
      //공백 상태로 checkList 추가 불가
      if(title != null && title.trim().isNotEmpty) {
        todoList.add(TodoItem(title: title, mbti: mbti,isCompleted: false));
      } else{
        // input text=null이면, isnull=1로 지정해 add버튼 실행 시 saveList(),clear 작업 생략
        isnull = 1;
      }
    });
  }

  void deleteTodoItem(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  void toggleTodoItem(int index) {
    setState(() {
      todoList[index].isCompleted = !todoList[index].isCompleted;
    });
  }

}