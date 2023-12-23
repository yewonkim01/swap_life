import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

class myMBTIreport extends StatefulWidget{
  @override
  myMBTIreportState createState() => myMBTIreportState();
}

class myMBTIreportState extends State<myMBTIreport> {
  kakao.User? user;
  List<String> checklist = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('🖤 MBTI report',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: FutureBuilder<List<String>>(
          future: getChecklist(),
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(),
            );
            } else if (snapshot.hasError) {
          return Center(
              child: Text('데이터를 불러오는 중에 오류가 발생했습니다.'),
              );
          } else {
          List<String> mbtilist = snapshot.data ?? [];

          return ListView.builder(
          itemCount: mbtilist.length,
          itemBuilder: (context, index) {
          String item = mbtilist[index];

          return ListTile(
          title: Text(item),
                  );
                },
                );
              }
              },
          ),
          );
        }

  Future<List<String>> getChecklist() async {
    final profile = FirebaseFirestore.instance;
    user = await kakao.UserApi.instance.me();
    DocumentSnapshot<Map<String, dynamic>> snapshot = await profile
        .collection('checklist')
        .doc(user!.id.toString())
        .collection('mychecklist')
        .doc('allchecklist')
        .get();

    List<String> mbtilist = [];

    if (snapshot.exists) {
      List<dynamic>? checklist = snapshot.data()?['checklist_mbti'];
      if (checklist != null) {
        mbtilist = checklist.cast<String>();
      }
    }
    return mbtilist;
  }

}
