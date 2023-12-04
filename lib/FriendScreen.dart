import 'package:flutter/material.dart';
import 'package:swap_life/friends/friendList.dart';

class FriendPage extends StatefulWidget {

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FriendList(),
        ],
      ),
    );
  }
}
