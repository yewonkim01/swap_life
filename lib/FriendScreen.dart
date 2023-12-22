import 'package:flutter/material.dart';
import 'package:swap_life/TodoScreen.dart';
import 'package:swap_life/friends/friendList.dart';
import 'dart:core';
import 'package:swap_life/shared/todo_controller.dart';

// 여기에 friend 창 구현 !!!
class FriendPage extends StatefulWidget {
  final TodoController controller;
  final List<String>? friendChecklist;
  final String? friendName;
  final int? exist;
  FriendPage({ required this.controller,required this.friendChecklist, required this.friendName, required this.exist});
  @override
  State<FriendPage> createState() => FriendPageState();
}

class FriendPageState extends State<FriendPage> {
  Map<int, String> emojiMap = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.friendChecklist!.length; i++) {
      emojiMap[i] = '😊';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60,),
          Text("< ${widget.friendName}'s checkList> ", style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold)),
          Text("친구의 일상을 경험하고, 완료사항을 체크해보세요"),
          Expanded(
              child: ListView(
                children: List.generate(
                  widget.friendChecklist?.length ?? 0,
                  (index) => ListTile(
                    leading: Checkbox(
                      activeColor: Colors.white,
                      checkColor: Colors.deepPurple,
                      value: todoList[index].isCompleted,
                      onChanged: (value) {
                        // checkBoxa상태 변경을 위한 bool 함수
                        _toggleTodoItem(index);
                      },
                    ),
                      title:  Text(
                        widget.friendChecklist![index],
                      ),
                      trailing:
                      DropdownButton<String?>(
                        value: emojiMap[index],
                        items:[
                          '😍',
                          '😀',
                          '😊',
                          '😑',
                          '😩'
                        ].map((String emoji) {
                          return DropdownMenuItem<String>(
                              value: emoji,
                            child: Text(
                              emoji,
                              style: TextStyle(fontSize: 24),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value){
                          setState(() {
                            emojiMap[index] = value!;
                          });
                        },
                      ),
                    ),
                ),
              )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: ElevatedButton(
                onPressed: () {

                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23.0),
                  child: Row(
                    children: [
                      Icon(Icons.smart_toy_sharp),
                      SizedBox(width: 60,),
                      Text('Finish', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
  void _toggleTodoItem(int index) {
    setState(() {
      todoList[index].isCompleted = !todoList[index].isCompleted;
    });
  }
}