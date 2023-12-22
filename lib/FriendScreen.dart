import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swap_life/TodoScreen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'dart:core';
import 'package:swap_life/shared/todo_controller.dart';

// 여기에 friend 창 구현 !!!
class FriendPage extends StatefulWidget {
  final List<String>? friendChecklist;
  final String? friendName;
  late TodoController controller;
  FriendPage({ required this.friendChecklist, required this.friendName});
  @override
  State<FriendPage> createState() => FriendPageState();
}

class FriendPageState extends State<FriendPage> {
  Map<int, String> emojiMap = {};
  String mbtivalue = ' ';
  List<int> emojiValue = [];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.friendChecklist!.length; i++) {
      emojiMap[i] = '😊';
    }
  }

  void emojiToint(emoji) async {
    for(int i =0; i<widget.friendChecklist!.length; i++) {
      {
        switch (emoji[i]) {
          case '😍':
            emojiValue[i] = 100;
            break;
          case '😀':
            emojiValue[i] = 80;
            break;
          case '😊':
            emojiValue[i] = 60;
            break;
          case '😑':
            emojiValue[i] = 40;
            break;
          case '😩':
            emojiValue[i] = 20;
            break;
        }
      }
    }
  }

  // void saveAll() async {
  //   kakao.User? user = await kakao.UserApi.instance.me();
  //   final db = FirebaseFirestore.instance;
  //   DocumentReference Ref = db.collection('checklist').doc(user!.id.toString());
  //   DocumentSnapshot mine = await Ref.get();
  //   for(int i=0; i<widget.friendChecklist!.length; i++ ) {
  //     {
  //       if (mine.data() == null) {
  //         await Ref.set({
  //           "${widget.friendName}": {'MBTI': emojiValue[i] ,
  //             'checklist' : widget.friendChecklist?[i]}
  //         });
  //       }
  //       else{
  //         await Ref.update(
  //           {
  //             "${widget.friendName}": {'MBTI': emojiValue[i] ,
  //               'checklist' : widget.friendChecklist?[i]}
  //           }
  //         );
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("${widget.friendName}'s checkList", style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold)),
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
          ElevatedButton(
              onPressed: () {
                emojiToint(emojiMap);
                // saveAll();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23.0),
                child: Row(
                  children: [
                    Icon(Icons.smart_toy_sharp),
                    Text('Finish', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
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