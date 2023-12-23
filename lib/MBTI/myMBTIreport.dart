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
      body: ListView(

      ),
    );
  }
  Future<void> getChecklist() async{
    final profile = FirebaseFirestore.instance;
    user = await kakao.UserApi.instance.me();
    await profile.collection('checklist').doc(user!.id.toString())
        .collection('mychecklist').doc('allchecklist').get();
  }
}
