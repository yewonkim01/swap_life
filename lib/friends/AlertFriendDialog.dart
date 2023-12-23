import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;




class AlertFriendDialog extends StatelessWidget {
  String? userid;
  kakao.User? user;
  final db = FirebaseFirestore.instance;


  AlertFriendDialog({this.userid});

  Future<List<Widget>> addAlarm() async {
    user = await kakao.UserApi.instance.me();
    var userid = user!.id.toString();
    List<Widget> alarm_ListTileitem = [];



    DocumentReference Ref = await db.collection('Alarm').doc(userid);
    DocumentSnapshot Alarm_db = await Ref.get();
    Map<String, dynamic>? Alarm = Alarm_db.data() as Map<String, dynamic>?;

    List AlarmList = Alarm!['userID'];
    String timestamp = Alarm!['timestamp'].toDate().toString();
    for(int i = 0; i<AlarmList.length; i++){
      String alarmid = AlarmList[i];
      DocumentSnapshot alarmdata = await db.collection('MyProfile')
          .doc(alarmid)
          .get();
      Map<String, dynamic>? alarmid_info = alarmdata.data() as Map<String, dynamic>?;
      var ImageUrl = alarmid_info!['ImageUrl'];
      var friendName = alarmid_info!['profileID'];

      alarm_ListTileitem.add(Column(
        children: [
          ListTile(
            leading: (ImageUrl == null)
                ? CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage('assets/profile.png'),
              backgroundColor: Colors.deepPurple[50],
            ) : CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(ImageUrl!),
            ),
            title: Text('${friendName}님이 나를 친구 추가했습니다.'),
            subtitle: Text('${timestamp.substring(0,10)}'),
          ), SizedBox()]));
    }
    return alarm_ListTileitem;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(child: Text('알림')),
        leading: IconButton(
            onPressed: (){Navigator.pop(context);},
            icon: Icon(Icons.arrow_back_ios),
      ),
    ),
    body: FutureBuilder<List<Widget>>(
        future: addAlarm(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
          }else if(snapshot.data == null){
            return Container();
          } else{
            final alarm_itemlist = snapshot.data;

            return ListView.builder(
              itemCount: alarm_itemlist!.length,
              itemBuilder: (context, index){
                return alarm_itemlist[index];
              },
            );
          }
        }
        )
    );
  }
}





