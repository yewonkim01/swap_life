import 'package:flutter/material.dart';

class FriendIcon extends StatefulWidget {
  String? imageUrl;
  String? NickName;

  //생성자로 초기화
  FriendIcon(var imageUrl, var NickName){
    this.imageUrl = imageUrl;
    this.NickName = NickName;
  }

  @override
  State<FriendIcon> createState() => _FriendIconState();
}

class _FriendIconState extends State<FriendIcon> {
  late var _imageUrl;
  late var _NickName;

  @override
  void initState(){
    super.initState();
    _imageUrl = widget.imageUrl!;
    _NickName = widget.NickName!;

  }

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        (_imageUrl == 'null') ? CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('assets/profile.png'),
          backgroundColor: Colors.deepPurple[50],
        ) : CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(_imageUrl),
        ),
        (_NickName == 'null') ? Text("  ")
         : Text('${_NickName}')
      ],
    );
  }
}


