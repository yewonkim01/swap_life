import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swap_life/MBTI/report_when_finish.dart';

class Mbti_report extends StatefulWidget {
  final String friendid;
  final String friendName;

  Mbti_report({
    required this.friendid, required this.friendName
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
                      "Finish ${widget.friendName}'s list",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${widget.friendName}의 리스트를 완료했어요!',
                      style: TextStyle(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 80),
                    Text(
                      '오늘 나의 MBTI는',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    SliderWidget(friendid: widget.friendid),
                    SizedBox(height: 30,),
                    ElevatedButton(
                        onPressed:() {
                          Navigator.pushNamed(context, '/myHome');
                        },
                        child: Text("EXIT"),
                    )
                  ],
                ),
              ),
        ),
        ),
    );
  }
}
