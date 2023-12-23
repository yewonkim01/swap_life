import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AddAlarm.dart';



class FriendListManager {
  final db = FirebaseFirestore.instance;
  String? userid_img;
  String? friendid_img;
  String? userid_profileid;
  String? friendid_profileid;

  Future<void> addFriendList(BuildContext context, String friendid, String userid) async {
    DocumentReference Ref = db.collection('MyFriends').doc(userid);
    DocumentSnapshot friends = await Ref.get();

    DocumentReference friendRef = db.collection('MyFriends').doc(friendid);
    DocumentSnapshot me = await friendRef.get();

    DocumentReference user_ProfileRef = db.collection('MyProfile').doc(userid);
    DocumentSnapshot user_profile_db = await user_ProfileRef.get();
    Map<String, dynamic>? user_profileData = user_profile_db.data() as Map<String, dynamic>?;

    DocumentReference friend_ProfileRef = db.collection('MyProfile').doc(friendid);
    DocumentSnapshot friend_profile_db = await friend_ProfileRef.get();
    Map<String, dynamic>? friend_profileData = friend_profile_db.data() as Map<String, dynamic>?;





    if (userid == friendid) {
      print('자기자신을 친구로 추가할 수 없습니다.');
      return;
    }
    if (friends.data() == null) {
      await Ref.set(
          {
            "FriendID": [friendid]
          }
      );
      addAlarm(me: 'userid', db: db, userid: userid, friendid: friendid, alarm_index: 0);
    } else {

      Map<String, dynamic>? friendsdata = friends.data() as Map<String, dynamic>?;
      List<dynamic> userid_friends = friendsdata!['FriendID'];

      if (userid_friends.contains(friendid)) {
        print('이미 추가된 친구입니다.');
        return;
      } else {
        userid_friends.add(friendid);
        await Ref.set({
          "FriendID": userid_friends
        }).then((value) {
          addAlarm(me: 'userid', db: db, userid: userid, friendid: friendid, alarm_index: 0);
        });}}

    if (me.data() == null) {
      await friendRef.set(
          {
            "FriendID": [userid]
          }
      );
      addAlarm(me: 'friendid', db: db, userid: userid, friendid: friendid, alarm_index: 0);
    } else {
      Map<String, dynamic>? mydata = me.data() as Map<String, dynamic>?;
      List<dynamic> friends_userid = mydata!['FriendID'];
      friends_userid.add(userid);
      await friendRef.set({
        "FriendID": friends_userid
      }).then((value) {
        addAlarm(me: 'friendid', db: db, userid: userid, friendid: friendid, alarm_index: 0);
      });
    }
  }
}

