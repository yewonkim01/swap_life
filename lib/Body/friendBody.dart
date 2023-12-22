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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FriendList(widget.controller, context),
          SizedBox(height: 25,),
          Expanded(
            child: FriendPage(
              controller: widget.controller,
              friendChecklist: widget.friendChecklist,
              friendName: widget.friendName,
              exist: widget.exist,
            ),
          ),
          /*exist == 0
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
              : */
        ],
      ),
    );
  }
}

class FriendMain extends StatefulWidget {
  final TodoController controller;
  final List<String> friendChecklist;
  final String? friendName;
  final int? exist;
  FriendMain({required this.controller,required this.friendChecklist, required this.friendName, required this.exist});
  @override
  _FriendMainState createState() => _FriendMainState();
}

class _FriendMainState extends State<FriendMain> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/alert_dialog');
          },
          icon: Icon(Icons.cloud_outlined),
        ),
        iconTheme: IconThemeData(color: Colors.deepPurple),
        title: Text("Swap Life"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: friendBody(controller: widget.controller,
        friendChecklist: widget.friendChecklist,
        friendName: widget.friendName,
        exist: 1,),
    );
  }
}