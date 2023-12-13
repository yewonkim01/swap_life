import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swap_life/friends/deleteFriendDialog.dart';
import 'package:swap_life/FriendScreen.dart';


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

  Future<List<Map<String, dynamic>>> getFriendChecklist(String friendid) async {
    List<Map<String, dynamic>> friendChecklist = [];
    try {
      // Firestore 쿼리: friendid를 사용하여 해당 친구의 체크리스트 가져오기
      QuerySnapshot checklistSnapshot = await FirebaseFirestore.instance
          .collection('checklist').doc(friendid).collection('user_checklist').get();
      // 가져온 데이터를 friendChecklist에 추가
      friendChecklist = checklistSnapshot.docs.map((DocumentSnapshot document) {
        return document.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print('Error fetching friend checklist: $e');
    } return friendChecklist;
  }

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
                SizedBox(width: 50,),
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
              onPressed: () async {
                List<Map<String, dynamic>> friendChecklist = await getFriendChecklist(friendid!);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FriendPage(
                      friendChecklist: friendChecklist,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23.0), // 좌우 여백 조절
                child: Row(
                  children: [
                    Icon(Icons.mail_outline_outlined, size: 50),
                    SizedBox(width: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Get Checklist', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                        Text('친구 리스트 가져오기'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            TextButton(
              onPressed: (){DeleteFriendDialog(context, doc!, frienddoc!, friendlist!, friendid!, myfriendlist!, userid!);},
              child: Text('delete friend', style: TextStyle(fontSize: 17,decoration: TextDecoration.underline),),
            ),
          ],
        ),
      ),
    );
  }
}