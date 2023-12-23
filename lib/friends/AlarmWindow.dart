import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;




class AlertFriend extends StatelessWidget {
  String? userid;
  kakao.User? user;
  final db = FirebaseFirestore.instance;


  AlertFriend({this.userid});

  Future<List<Widget>> addAlarm() async {
    user = await kakao.UserApi.instance.me();
    var userid = user!.id.toString();
    List<Widget> alarm_ListTileitem = [];


    DocumentReference Ref = await db.collection('Alarm').doc(userid);
    DocumentSnapshot Alarm_db = await Ref.get();
    Map<String, dynamic> Alarm = Alarm_db.data() as Map<String, dynamic>;
    var AlarmList = Alarm!['info'];

    for(int i = 0; i<AlarmList.length; i++){
      Map alarm_item = AlarmList[i];
      String timestamp = alarm_item['timestamp'].toDate().toString();
      int alarm_info = alarm_item['alarm_info'];
      print('${alarm_item}, ${timestamp}. ${alarm_info}');
      DocumentSnapshot alarmdata = await db.collection('MyProfile')
          .doc(alarm_item['userID'])
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
            title: Row(
              children: alarm_info == 0?
              [Text('${friendName}', style: TextStyle(fontWeight: FontWeight.bold),),
                Text('님이 나를 친구로 추가했습니다.')]
                  :
              [Text('${friendName}', style: TextStyle(fontWeight: FontWeight.bold),),
                Text('님이 나의 일상을 담았습니다.')],
            ),
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
            return Center(child: CircularProgressIndicator());
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





