import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addAlarm({String? me, FirebaseFirestore? db, String? userid, String? friendid, required int? alarm_index}) async{
  late DocumentReference AlarmRef;
  late DocumentSnapshot Alarm_db;
  var add_id;

  print('여기부터 시작 userid ${userid}       friendid ${friendid}');
  DocumentReference user_AlarmRef = db!.collection('Alarm').doc(userid);
  DocumentSnapshot user_Alarm_db = await user_AlarmRef.get();

  DocumentReference friend_AlarmRef = db!.collection('Alarm').doc(friendid);
  DocumentSnapshot friend_Alarm_db = await friend_AlarmRef.get();

  DateTime now = DateTime.now();

  if (alarm_index == 0){
    print(1);
    AlarmRef = (me == 'userid') ? user_AlarmRef : friend_AlarmRef;
    Alarm_db = (me == 'userid') ? user_Alarm_db : friend_Alarm_db;
    add_id = (me == 'userid') ? friendid : userid;
  }else{
    print(2);
    AlarmRef = friend_AlarmRef;
    Alarm_db = friend_Alarm_db;
    add_id = userid;
  }
  print('add_id : $add_id,    $alarm_index    userid: $userid      friendid: $friendid');


  if (Alarm_db.data() == null) {
    await AlarmRef.set({
      "info": [{"userID": add_id, "timestamp": now, "alarm_info": alarm_index}]
    });
    print("db null: ${Alarm_db.data()}");
  }else{
    Map<String, dynamic>? Alarmdata = Alarm_db.data() as Map<String, dynamic>?;
    print("alarm_db: null 아님${Alarm_db.data()}");
    List alarm_data = Alarmdata!['info'];
    alarm_data.add({"userID": add_id, "timestamp": now, "alarm_info": alarm_index});
    await AlarmRef.set({
      "info": alarm_data
    });
  }
}
