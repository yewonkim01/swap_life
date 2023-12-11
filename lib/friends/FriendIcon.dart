import 'package:flutter/material.dart';

class FriendIcon extends StatelessWidget {
  final String? imageUrl;
  final String? NickName;
  //생성자로 초기화
  FriendIcon({Key? key, this.imageUrl, this.NickName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FriendProfileScreen(imageUrl: imageUrl, NickName: NickName),
          ),
        );
      },
      child: Column(
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
      ),
    );
  }
}

class FriendProfileScreen extends StatelessWidget {
  final String? imageUrl;
  final String? NickName;

  // 생성자로 초기화
  FriendProfileScreen({Key? key, this.imageUrl, this.NickName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (imageUrl == 'null')
                ? CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('assets/profile.png'),
              backgroundColor: Colors.deepPurple[50],
            )
                : CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(imageUrl!),
            ),
            SizedBox(height: 20),
            (NickName == 'null') ? Text("  ") : Text('$NickName', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}


