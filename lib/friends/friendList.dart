import 'package:flutter/material.dart';
import 'KakaoTalkShare.dart';
import 'dynamicLink.dart';
import 'package:swap_life/shared/todo_controller.dart';
import 'FriendIcon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;




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
  var friendlist;
  var mylist;


  Future<List<Widget>> getFriend() async{
    user = await kakao.UserApi.instance.me();
    var userid = user!.id.toString();
    List<Widget> update_friendIconList = [];

    if(userid != null){
      final doc = await db.collection('MyFriends').doc(userid);
      DocumentSnapshot snapshot = await doc.get();

      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      friendlist = data!['FriendID'];

      for(int i = 0; i<friendlist.length; i++) {
        var friend = friendlist[i];
        print('이게 friend!!!${friend}');
        DocumentSnapshot friends = await db.collection('MyProfile')
            .doc(friend)
            .get();

        final frienddoc = await db.collection('MyFriends').doc(friend);
        DocumentSnapshot friendsnapshot = await doc.get();

        Map<String, dynamic>? frienddata = friendsnapshot.data() as Map<String, dynamic>?;
        mylist = frienddata!['FriendID'];




        Map<String, dynamic>? friendProfile = friends.data() as Map<String, dynamic>?;
        var ImageUrl = friendProfile!['ImageUrl'];
        var profileId = friendProfile!['profileID'];
        var MBTI = friendProfile!['MBTI'];
        var intro = friendProfile!['intro']; //한줄소개

        if (ImageUrl == null) {
          ImageUrl = 'null';
        }
        if (profileId == null) {
          profileId = 'null';
        }

        update_friendIconList.add(
            GestureDetector(
              onLongPress: (){
                showDialog(
                    context: context,
                    builder: ((context){
                      return AlertDialog(
                        content: Text('친구를 삭제하시겠습니까?',style: TextStyle(fontSize: 17),),
                        actions: [
                          TextButton(onPressed: () async{
                            (friendlist.length == 1)?
                            await doc.set({"FriendID" : []}) :
                            doc.update({'FriendID':FieldValue.arrayRemove([friend])});

                            (mylist.length == 1)?
                            await frienddoc.set({"FriendID" : []}) :
                            frienddoc.update({'FriendID':FieldValue.arrayRemove([userid])});

                            Navigator.of(context).pop();
                            },
                              child: Text('YES')),
                          TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('NO')),
                        ],
                      );
                    }
                    )
                );
              },
              child: Container(
                //alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                //color: Colors.red,
                width: 80,
                height: 80,
                child: FriendIcon(imageUrl: ImageUrl, NickName: profileId, MBTI: MBTI, intro: intro,),
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
            return CircularProgressIndicator();
          }else if(snapshot.data == null){
            return returnContainer([Container()], widget.controller, widget.context);
          }else{
            friendIconList = snapshot.data;
            return returnContainer(friendIconList, widget.controller, widget.context);
          }
        }
    );

  }
}


//전체 Friend리스트 위 창 클래스
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
