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
      body: ListView(
        children: [
          SizedBox(height: 10),
          FriendList(widget.controller, context),
          widget.friendChecklist == null
              ? SizedBox(
            height: 200,
            child: Center(
              child: Text("Friend's List", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic,),),
            ),
          )
              : FriendPage(
            friendChecklist: widget.friendChecklist, // Provide the friendChecklist data if needed
          ),
        ],
      ),
    );
  }
}