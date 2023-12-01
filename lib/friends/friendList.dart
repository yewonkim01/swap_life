import 'package:flutter/material.dart';

class FriendList extends StatefulWidget {

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          alignment: Alignment.bottomLeft,
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: Text('Friend', style: TextStyle(fontSize: 20)),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black26),
              top: BorderSide(color: Colors.black26),
            )
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                width: 80,
                height: 80,
                child: Icon(Icons.account_circle, color: Colors.black26,size: 20,),
              ),
              Container(
                width: 80,
                height: 80,
                child: Icon(Icons.account_circle, color: Colors.black26,),
              ),
              Container(
                width: 80,
                height: 80,
                child: Icon(Icons.account_circle, color: Colors.black26,),
              ),
              Container(
                width: 80,
                height: 80,
                child: Icon(Icons.account_circle, color: Colors.black26,),
              ),
              Container(
                width: 80,
                height: 80,
                child: Icon(Icons.account_circle, color: Colors.black26,),
              ),
              Container(
                width: 80,
                height: 80,
                child: Icon(Icons.account_circle, color: Colors.black26,),
              ),
              Container(
                width: 80,
                height: 80,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
