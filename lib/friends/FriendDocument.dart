import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FriendListManager{
  final db = FirebaseFirestore.instance;

  Future<void> addFriendList(BuildContext context, String friendid, String userid) async {
    DocumentReference Ref = db.collection('MyFriends').doc(userid);
    DocumentSnapshot friends = await Ref.get();


    DocumentReference friendRef = db.collection('MyFriends').doc(friendid);
    DocumentSnapshot me = await friendRef.get();


    if (userid == friendid) {
      print('자기자신을 친구로 추가할 수 없습니다.');
      return;
    }
    if (friends.data() == null){
      await Ref.set(
          {
            "FriendID": [friendid]
          }
      );
    }else{
      Map<String, dynamic>? friendsdata = friends.data() as Map<String, dynamic>?;
      List<dynamic> userid_friends = friendsdata!['FriendID'] ;

      if(userid_friends.contains(friendid)){
        print('이미 추가된 친구입니다.');
        return;
      }else{
        userid_friends.add(friendid);
        await Ref.set({
          "FriendID": userid_friends
        }).then((value) {
          print('update 완료');
        });
      }
    }


    if (me.data() == null) {
      await friendRef.set(
          {
            "FriendID": [userid]
          }
      );
    }else{
      Map<String, dynamic>? mydata = me.data() as Map<String, dynamic>?;
      List<dynamic> friends_userid = mydata!['FriendID'];
      friends_userid.add(userid);
      await friendRef.set({
        "FriendID": friends_userid
      }).then((value) {
        print('update 완료');
      });
    }








    // if (userid == friendid) {
    //   print('자기자신을 친구로 추가할 수 없습니다.');
    // } else {
    //   print(1);
    //   if (friends.data() == null) {
    //     print(2);
    //     await Ref.set(
    //         {
    //           "FriendID": [friendid]
    //         }
    //     );
    //   }
    //   if (me.data() == null) {
    //     print(3);
    //     await friendRef.set(
    //         {
    //           "FriendID": [userid]
    //         }
    //     );
    //   }
    //   if (userid_friends.contains(friendid)) {
    //     print('friend 중복됨');
    //   } else {
    //     print(4);
    //     userid_friends.add(friendid);
    //     friends_userid.add(userid);
    //
    //     await Ref.set({
    //       "FriendID": userid_friends
    //     }).then((value) {
    //       print('update 완료');
    //     });
    //
    //     await friendRef.set({
    //       "FriendID": friends_userid
    //     }).then((value) {
    //       print('update 완료');
    //     });
    //   }
    // }


    //collection 초기화
//     if (friends.data() == null){
//       if (userid != null){
//         if(userid != friendid){
//           await Ref.set(
//               {
//                 "FriendID": []
//               }
//           );
//           await friendRef.set(
//               {
//                 "FriendID": []
//               }
//           );
//         }else{
//           print('자기자신을 친구로 추가할 수 없습니다.');
//         }
//       }
//     }else{
//       List<dynamic> fList = friends['FriendID'];
//       List<dynamic> me_fList = me['FriendID'];
//
//       if (fList.contains(friendid)){
//         print('friends 중복됨');
//         // showDialog(
//         //     context: context,
//         //     builder: (context){
//         //       return AlertDialog(
//         //         content: Container(child: Text('이미 친구인 사용자입니다.'),),
//         //       );
//         //     }
//         // );
//       }else{
//         print('${fList}::::: ${me_fList}');
//         fList.add(friendid);
//         me_fList.add(userid);
//
//         await Ref.set({
//           "FriendID": fList
//         }).then((value) {print('update 완료');});
//
//         await friendRef.set({
//           "FriendID": me_fList
//         }).then((value) {print('update 완료');});
//       }
//
//     }
   }
  }
