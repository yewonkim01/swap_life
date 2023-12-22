import 'package:flutter/material.dart';
import 'package:swap_life/FriendScreen.dart';
import 'package:swap_life/friends/friendList.dart';
import 'package:swap_life/shared/todo_controller.dart';

class friendBody extends StatefulWidget {
  final TodoController controller;
  final List<String> friendChecklist;
  final String? friendName;
  final int? exist;
  friendBody({ required this.controller,required this.friendChecklist, required this.friendName, required this.exist});

  @override
  friendBodyState createState() => friendBodyState();
}

class friendBodyState extends State<friendBody> {
  bool showFriendList = true;
  int exist = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                FriendList(widget.controller, context),
                exist == 0
                    ? SizedBox(
                  height: 500,
                  child: Center(
                    child: Text(
                      "Friend's List",
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                )
                    : FriendPage(
                  controller: widget.controller,
                  friendChecklist: widget.friendChecklist,
                    friendName: widget.friendName,
                    exist: widget.exist
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
