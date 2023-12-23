import 'package:flutter/material.dart';
import 'KakaoTalkShare.dart';
import 'package:swap_life/shared/todo_controller.dart';
import 'FriendIcon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:swap_life/friends/deleteFriendDialog.dart';
import 'package:swap_life/friends/FriendProfile.dart';



class FriendList extends StatefulWidget {
  late TodoController controller;
  late BuildContext context;
  FriendList(TodoController controller, BuildContext context){
    this.controller = controller;
    this.context = context;
  }
  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  final db = FirebaseFirestore.instance;
  kakao.User ? user;
  late List friendlist;
  late List myfriendlist;
  late DocumentReference doc;
  late DocumentReference frienddoc;

  //firestore에서 친구 리스트 가져오는 함수
  Future<List<Widget>> getFriend() async{
    user = await kakao.UserApi.instance.me();
    var userid = user!.id.toString();
    List<Widget> update_friendIconList = [];

    if(userid != null){
      doc = await db.collection('MyFriends').doc(userid);
      DocumentSnapshot snapshot = await doc.get();

      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      friendlist = data!['FriendID'];

      for(int i = 0; i<friendlist.length; i++) {
        String friendid = friendlist[i];
        DocumentSnapshot friends = await db.collection('MyProfile')
            .doc(friendid)
            .get();

        frienddoc = await db.collection('MyFriends').doc(friendid);
        DocumentSnapshot friendsnapshot = await doc.get();

        Map<String, dynamic>? frienddata = friendsnapshot.data() as Map<String, dynamic>?;
        myfriendlist = frienddata!['FriendID'];

        Map<String, dynamic>? friendProfile = friends.data() as Map<String, dynamic>?;
        var ImageUrl = friendProfile!['ImageUrl'];
        var NickName = friendProfile!['profileID'];

        var MBTI = friendProfile!['MBTI'];
        var intro = friendProfile!['Introduction']; //한줄소개

        if (ImageUrl == null) {
          ImageUrl = 'null';
        }
        if (NickName == null) {
          NickName = 'null';
        }

        update_friendIconList.add(
            GestureDetector(
              //꾹 누르면 친구 삭제
              onLongPress: (){DeleteFriendDialog(context, doc, frienddoc, friendlist, friendid, myfriendlist, userid);},
              //탭하면 친구 프로필창 나옴
              onTap: ()  {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FriendProfile(userid: userid, friendid: friendid, doc: doc, frienddoc: frienddoc, friendlist: friendlist, myfriendlist: myfriendlist, imageUrl: ImageUrl, NickName: NickName, MBTI: MBTI, intro: intro,controller: widget.controller,),
                ),
              );
              },
              child: Container(
                //alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                //color: Colors.red,
                width: 80,
                height: 80,
                child: FriendIcon(imageUrl: ImageUrl, NickName: NickName),
              ),
            )
        );
      }
    }else{
      print('user는 null입니다.');
    }
    return update_friendIconList;
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> friendIconList;

    return FutureBuilder(
        future: getFriend(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else if(snapshot.data == null){
            return returnContainer([Container()], widget.controller, widget.context);
          }else{
            friendIconList = snapshot.data;
            // Future.delayed(Duration.zero, (){
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('되지롱')));
            // });


            // Future.delayed(Duration.zero, (){
            //   showDialog(context: context, builder: (context){
            //     return AlertDialog(
            //       content: Text('위젯'),
            //     );
            //   });
            // });


            return returnContainer(friendIconList, widget.controller, widget.context);
          }
        }
    );

  }
}


//전체 Friend리스트 박스 컨테이너 (여기 안에 친구들이 추가됨)
class returnContainer extends StatefulWidget {
  List<Widget>? friendIconList;
  TodoController? controller;
  BuildContext? context;

  returnContainer(List<Widget> friendIconList, TodoController controller, BuildContext context){
    this.friendIconList = friendIconList;
    this.controller = controller;
    this.context = context;
  }


  @override
  State<returnContainer> createState() => _returnContainerState();
}

class _returnContainerState extends State<returnContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 120,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            alignment: Alignment.bottomLeft,
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: Text('Friend', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
            child: Stack(
              children: [
                ListView(
                  scrollDirection: Axis.horizontal,
                  children: widget.friendIconList ?? []
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width - 40,
                  top: 20,
                  child: GestureDetector(
                    onTap: (){
                      showDialog(
                          barrierColor: Colors.transparent,
                          barrierDismissible: true,
                          context: context,
                          builder: (context){
                            // final d = DynamicLink(controller: widget.controller);
                            // d.buildDynamicLink();
                            return KakaoShareButton(controller: widget.controller!);
                          });
                    },
                    child: Container(
                      width: 30,
                      height: 37,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.black54)
                      ),
                      child: Icon(Icons.add, color: Colors.black87,),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



