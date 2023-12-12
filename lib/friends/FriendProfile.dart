import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swap_life/friends/deleteFriendDialog.dart';




class FriendProfile extends StatelessWidget {
  late String? imageUrl;
  late String? NickName;
  late String? MBTI;
  late String? intro; //한줄소개
  late String? userid;
  late String? friendid;
  late DocumentReference? doc;
  late DocumentReference? frienddoc;
  late List? friendlist;
  late List? myfriendlist;


  // 생성자로 초기화
  FriendProfile({Key? key, this.userid, this.friendid, this.doc, this.frienddoc, this.friendlist, this.myfriendlist, this.imageUrl, this.NickName, this.MBTI, this.intro}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.exit_to_app_outlined),
          onPressed: () {Navigator.of(context).pop();},
        ),
        title: Text('Friend Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(width: 30,),
                (imageUrl == 'null')
                    ? CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/profile.png'),
                  backgroundColor: Colors.deepPurple[50],
                )
                    : CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(imageUrl!),
                ),
                SizedBox(width: 70,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (NickName == 'null') ? Text("  ") : Text('$NickName', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
                    SizedBox(height: 10,),
                    (MBTI == 'null') ? Text("MBTI") : Text('$MBTI', style: TextStyle(fontSize: 22),),
                    (intro == 'null') ? Text("상태메시지") : Text('$intro', style: TextStyle(fontSize: 20),)
                  ],
                ),
              ],
            ),
            SizedBox(height: 70,),
            // 친구 checklist끌어오기..
            Text("< ${NickName}'s List >",style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 270,),
            ElevatedButton(
              onPressed: (){},
              child: Row(
                children: [
                  Icon(Icons.mail_outline_outlined, size: 50),
                  SizedBox(width: 50,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Get Checklist', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                      Text('친구 리스트 가져오기')
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){DeleteFriendDialog(context, doc!, frienddoc!, friendlist!, friendid!, myfriendlist!, userid!);},
              child: Text('delete friend', style: TextStyle(fontSize: 17,),),
            ),
          ],
        ),
      ),
    );
  }
}