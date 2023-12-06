import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class FriendListManager{
  String? frienduser;
  final db = FirebaseFirestore.instance;

  Future<void> addFriendList(BuildContext context, String friendid, String userid) async{
    DocumentReference Ref = db.collection('MyFriends').doc(userid);
    DocumentSnapshot friends =  await Ref.get();


    DocumentReference friendRef = db.collection('MyFriends').doc(friendid);
    DocumentSnapshot me =  await Ref.get();




    //collection 초기화
    if (friends.data() == null){
      print('friends data는 null');
      if (userid != null){
        print('user가 null이 아닐 때');
        if(userid != friendid){
          print('user랑 friend랑 같을 때');
          await Ref.set(
              {
                "FriendID": [friendid]
              }
          );
          await friendRef.set(
              {
                "FriendID": [userid]
              }
          );
        }else{
          print('자기자신을 친구로 추가할 수 없습니다.');
        }
      }
    }else{
      List<dynamic> fList = friends['FriendID'];
      List<dynamic> me_fList = me['FriendID'];

      if (fList.contains(friendid)){
        print('friends 중복됨');
        // showDialog(
        //     context: context,
        //     builder: (context){
        //       return AlertDialog(
        //         content: Container(child: Text('이미 친구인 사용자입니다.'),),
        //       );
        //     }
        // );
      }else{
        fList.add(friendid);
        me_fList.add(userid);

        await Ref.set({
          "FriendID": fList
        }).then((value) {print('update 완료');});

        await friendRef.set({
          "FriendID": me_fList
        }).then((value) {print('update 완료');});
      }

    }
  }
}