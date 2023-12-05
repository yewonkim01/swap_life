import 'package:flutter/material.dart';
import 'package:swap_life/TodoScreen.dart';
import 'package:swap_life/friends/friendList.dart';
import 'package:swap_life/shared/todo_controller.dart';

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
          FriendList(controller: widget.controller),
          //친구 list 없을 땐, sizebox랑 Text 삼항연산자로 띄우기
          SizedBox(height: 270),
          Text( "Friend's List", style: TextStyle(color: Colors.grey,fontStyle: FontStyle.italic),),
        ],
      ),
    );
  }
}
