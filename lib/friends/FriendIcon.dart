import 'package:flutter/material.dart';

class FriendIcon extends StatelessWidget {
  final String? imageUrl;
  final String? NickName;

  //생성자로 초기화
  FriendIcon({Key? key, this.imageUrl, this.NickName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (imageUrl == 'null')
            ? CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('assets/profile.png'),
          backgroundColor: Colors.deepPurple[50],
        )
            : CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(imageUrl!),
        ),
        (NickName == 'null') ? Text("  ") : Text('$NickName'),
      ],
    );
  }
}




