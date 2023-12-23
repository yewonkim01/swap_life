import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<dynamic> DeleteFriendDialog(BuildContext context, DocumentReference doc, DocumentReference frienddoc, List friendlist, String friendid, List myfriendlist, String userid){
  return showDialog(
    context: context,
    builder: ((context){
      return AlertDialog(
        title:Text('⚠ 친구를 삭제하시겠습니까?',style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
        content: Text('진행 중이던 CheckList에 대한 정상적인 MBTI report평가 불가',style: TextStyle(fontSize: 14),),
        actions: [
          TextButton(onPressed: () async{
            (friendlist.length == 1)?
            await doc.set({"FriendID" : []}) :
            doc.update({'FriendID':FieldValue.arrayRemove([friendid])});

            (myfriendlist.length == 1)?
            await frienddoc.set({"FriendID" : []}) :
            frienddoc.update({'FriendID':FieldValue.arrayRemove([userid])});
            Navigator.of(context).pop();
          },
              child: Text('YES')),
          TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('NO')),
        ],
      );
    })
  );

}