import 'package:flutter/material.dart';
import 'package:swap_life/FriendScreen.dart';
import 'package:swap_life/friends/friendList.dart';
import 'package:swap_life/shared/todo_controller.dart';

class friendBody extends StatefulWidget {
  final TodoController controller;
  final List<String> friendChecklist;
  final String? friendName;
  friendBody({super.key, required this.controller, required this.friendChecklist,required this.friendName});

  @override
  friendBodyState createState() => friendBodyState();
}

class friendBodyState extends State<friendBody> {
  bool showFriendList = true;

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
                (widget.friendChecklist == null|| widget.friendChecklist.isEmpty)
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
                  friendChecklist: widget.friendChecklist,
                    friendName: widget.friendName,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
