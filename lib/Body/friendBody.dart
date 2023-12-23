import 'package:flutter/material.dart';
import 'package:swap_life/FriendScreen.dart';
import 'package:swap_life/friends/friendList.dart';
import 'package:swap_life/shared/todo_controller.dart';
import 'package:swap_life/main.dart';

class friendBody extends StatefulWidget {
  final TodoController controller;
  final List<String> friendChecklist;
  final String? friendName;
  final String friendid;
  friendBody({ required this.controller,required this.friendChecklist, required this.friendName,required this.friendid,});

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
              friendid: widget.friendid,
            ),
          ),
        ],
      ),
    );
  }
}

//친구 checklist가져왔을때의 Main화면 구성 -> 종료 버튼 누르면 원래 화면으로 돌아감
class FriendMain extends StatefulWidget {
  final TodoController controller;
  final List<String> friendChecklist;
  final String? friendName;
  final String friendid;
  FriendMain({required this.controller,required this.friendChecklist, required this.friendName,required this.friendid,});
  @override
  _FriendMainState createState() => _FriendMainState();
}

class _FriendMainState extends State<FriendMain> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
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
        friendid: widget.friendid,
      ),
      bottomNavigationBar: BottomNavBar(
        tabController: _tabController,
        selectedIndex: 0,
        onTabTapped: (index) {
        },
      ),,
    );
  }
}