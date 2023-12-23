import 'package:flutter/material.dart';
import 'package:swap_life/FriendScreen.dart';
import 'package:swap_life/friends/friendList.dart';
import 'package:swap_life/shared/todo_controller.dart';
import 'package:swap_life/main.dart';
import 'package:swap_life/MyProfile.dart';
import 'package:swap_life/TodoScreen.dart';

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
  TabController? _tabController;
  int _selectedIndex = 0;

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
      body: TabBarView(
        controller: _tabController,
        children: [
          friendBody(controller: widget.controller, friendChecklist: widget.friendChecklist, friendName: widget.friendName, friendid: widget.friendid),
          TodoScreen(controller: widget.controller),
          MyProfile(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        tabController: _tabController!,
        selectedIndex: _selectedIndex,
        onTabTapped: (index) {
          setState(() {
            _selectedIndex = index;
            _tabController!.index = index;
          });
        },
      ),
    );
  }
}