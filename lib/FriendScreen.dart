import 'package:flutter/material.dart';
import 'package:swap_life/TodoScreen.dart';
import 'package:swap_life/friends/friendList.dart';
import 'dart:core';
import 'package:swap_life/shared/todo_controller.dart';

class FriendPage extends StatefulWidget {
  final TodoController controller;
  final List<String>? friendChecklist;
  final String? friendName;
  FriendPage({ required this.controller,required this.friendChecklist, required this.friendName,});
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
          Text("< ${widget.friendName} checkList > ", style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold)),
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
            padding: const EdgeInsets.symmetric(horizontal: 70.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Icon(Icons.smart_toy_sharp),
                      SizedBox(width: 45,),
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
