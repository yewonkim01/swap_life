import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swap_life/friends/deleteFriendDialog.dart';
import 'package:swap_life/shared/todo_controller.dart';
import 'package:swap_life/Body/friendBody.dart';
import 'package:swap_life/FriendScreen.dart';


class FriendProfile extends StatefulWidget {
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
  late List<String>? friendChecklist;
  final TodoController controller;
  final int? exist;

  FriendProfile({
    Key? key,
    this.userid,
    this.friendid,
    this.doc,
    this.frienddoc,
    this.friendlist,
    this.myfriendlist,
    this.imageUrl,
    this.NickName,
    this.MBTI,
    this.intro,
    required this.controller,
    this.exist,
  }) : super(key: key);

  @override
  _FriendProfile createState() => _FriendProfile();
}
class _FriendProfile extends State<FriendProfile> {
  List<String>? friendChecklist;
  int? exist;

  @override
  void initState() {
    super.initState();
    exist = widget.exist;
    updatefriend();
  }

  void updatefriend() async{
    friendChecklist = await getFriendChecklist(widget.friendid!);
    setState(() {});
  }

  Future<List<String>> getFriendChecklist(String friendid) async {
    try {
      // Firestore 쿼리: friendid를 사용하여 해당 친구의 체크리스트 가져오기
      DocumentSnapshot checklistSnapshot = await FirebaseFirestore.instance
          .collection('checklist').doc(friendid).get();
      // 가져온 데이터를 friendChecklist에 추가
      Map<String, dynamic> datas = checklistSnapshot.data() as Map<String, dynamic>;
      List<String> titles = [];
      for (int i = 0; i < datas['user_checklist'].length; i++) {
        titles.add(datas['user_checklist'][i]['title']);
      }
      return titles;
    } catch (e) {
      print('Error fetching friend checklist: $e');
      return [];
    }
  }

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
            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(width: 30,),
                (widget.imageUrl == 'null')
                    ? CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/profile.png'),
                  backgroundColor: Colors.deepPurple[50],
                )
                    : CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(widget.imageUrl!),
                ),
                SizedBox(width: 50,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (widget.NickName == 'null') ? Text("  ") : Text('${widget.NickName}', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
                    SizedBox(height: 10,),
                    (widget.MBTI == 'null') ? Text("MBTI") : Text('${widget.MBTI}', style: TextStyle(fontSize: 22),),
                    (widget.MBTI == 'null') ? Text("상태메시지") : Text('${widget.intro}', style: TextStyle(fontSize: 20),)
                  ],
                ),
              ],
            ),
            SizedBox(height: 50,),
            // 친구 checklist끌어오기..
            Text("< ${widget.NickName}'s List >", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: showList(),
              ),
            ),
            SizedBox(height: 200),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23.0),
              child: ElevatedButton(
                onPressed: () async {
                  //버튼 누르면 새로운 Main 페이지로 이동
                  friendChecklist = await getFriendChecklist(widget.friendid!);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FriendMain(
                        controller: widget.controller,
                        friendChecklist: friendChecklist!,
                        friendName: widget.NickName!,
                        friendid: widget.friendid!,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23.0), // 좌우 여백 조절
                  child: Row(
                    children: [
                      Icon(Icons.mail_outline_outlined, size: 50),
                      SizedBox(width: 15),
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
            ),
            SizedBox(height: 15,),
            TextButton(
              onPressed: () async{
                DeleteFriendDialog(context, widget.doc!, widget.frienddoc!, widget.friendlist!, widget.friendid!, widget.myfriendlist!, widget.userid!);
              },
              child: Text('delete friend', style: TextStyle(fontSize: 17,decoration: TextDecoration.underline),),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> showList() {
    if (friendChecklist == null) {
      return []; // friendChecklist이 null인 경우 처리
    }

    List<Widget> lists = [];
    for (int i = 0; i < friendChecklist!.length; i++) {
      lists.add(Row(
        children: [
          SizedBox(width: 40),
          Icon(Icons.check),
          SizedBox(width: 10),
          Text(friendChecklist![i], style: TextStyle(fontSize: 17),),
        ],
      ));
    }
    return lists;
  }
}