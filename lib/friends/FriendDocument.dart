import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:cloud_firestore/cloud_firestore.dart';



class FriendListManager{
  String? frienduser;
  final db = FirebaseFirestore.instance;

  // Future<void> createFriendList(String friendid, String userid) async {
  //   DocumentReference Ref = db.collection('MyFriends').doc(userid);
  //   DocumentSnapshot friends =  await Ref.get();
  //   List<dynamic> fList = friends['FriendID'];
  //   if
  //   try {
  //     if (userid != null) {
  //       await db.collection('MyFriends').doc(userid).set(
  //           {
  //             "FriendID": []
  //           }
  //       );
  //     }
  //   else{
  //   print('null임');
  //   }
  // }catch (e){
  //     print('user는 null');
  //   }
  // }

  Future<void> addFriendList(BuildContext context, String friendid, String userid) async{
    DocumentReference Ref = db.collection('MyFriends').doc(userid);
    DocumentSnapshot friends =  await Ref.get();

    //collection 초기화
    if (friends.data() == null){
      if (userid != null) {
        print('freinds 컬렉션 생성, 아직 null');
        await db.collection('MyFriends').doc(userid).set(
            {
              "FriendID": [friendid]
            }
        );

      }
    }else{
      print('여기까지 오나?');
      List<dynamic> fList = friends['FriendID'];
      print('add 시작점');
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
        print('friends 중복아님 add 실행');
        fList.add(friendid);

        print('set 시작');
        await Ref.set({
          "FriendID": fList
        }).then((value) {print('update 완료');});
      }

    }
  }
}