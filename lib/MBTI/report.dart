import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:swap_life/MBTI/report_when_finish.dart';
import 'report_when_finish.dart';

class Mbti_report extends StatefulWidget {
  final String friendid;

  Mbti_report({
    required this.friendid,
  });

  @override
  State<Mbti_report> createState() => _Mbti_report();
}

class _Mbti_report extends State<Mbti_report> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('MBTI report'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      body:
      Container(
        child: SingleChildScrollView(
              child :Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      "Finish friend's list",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Friends의 리스트를 완료했어요!',
                      style: TextStyle(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 100),
                    Text(
                      '오늘 나의 MBTI는',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    SliderWidget(friendid: widget.friendid),

                    ElevatedButton(
                        onPressed:() {
                          Navigator.pushNamed(context, '/myHome');
                        },
                        child: Text("나가기"),
                    )
                  ],
                ),
              ),
        ),
        ),
    );
  }
}
