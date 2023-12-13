import 'package:flutter/material.dart';
import 'package:swap_life/FriendScreen.dart';
import 'package:swap_life/friends/friendList.dart';
import 'package:swap_life/shared/todo_controller.dart';

class friendBody extends StatefulWidget{
  final TodoController controller;
  final List<Map<String, dynamic>> friendChecklist;
  friendBody({required this.controller, required this.friendChecklist});

  @override
  _friendBody createState() => _friendBody();
}

class _friendBody extends State<friendBody> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 10),
          FriendList(widget.controller, context),
          //친구 list 없을 땐, sizebox랑 Text 삼항연산자로 띄우기
          //Text( "Friend's List", style: TextStyle(color: Colors.grey,fontStyle: FontStyle.italic),),
          FriendPage(friendChecklist: widget.friendChecklist),
        ],
      ),
    );
  }
}