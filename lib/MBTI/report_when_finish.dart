//김진영 작성
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swap_life/MBTI/calc_mbti.dart';
import 'report.dart' as report;

class calc_mbti extends StatefulWidget{
  final String friendid;

  calc_mbti({
    required this.friendid
});

  @override
  State<StatefulWidget> createState()=> _calc_mbit();
}

class _calc_mbit extends State<calc_mbti>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SliderWidget(friendid: widget.friendid,),
        ],
      ),
    );
  }
}

class SliderWidget extends StatefulWidget{
  final String friendid;
  SliderWidget({
    required this.friendid,
});
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget>{
  Future<void>? dataLoading;

  double Evalue = 0;
  double Ivalue =0;
  double Nvalue = 0;
  double Svalue = 0;
  double Fvalue = 0;
  double Tvalue = 0;
  double Jvalue = 0;
  double Pvalue = 0;
  String? MBTI = "";

  Future<void> getAll() async {
    getList mbtiCalculator = getList(friendid: widget.friendid);
    await mbtiCalculator.getProfile();
    await mbtiCalculator.processList();
    await mbtiCalculator.finalMBTI();
    MBTI = await mbtiCalculator.getMBTI();

    setState(() {
      Evalue = mbtiCalculator.E / 100;
      Ivalue = mbtiCalculator.I / 100;
      Nvalue = mbtiCalculator.N / 100;
      Svalue = mbtiCalculator.S / 100;
      Fvalue = mbtiCalculator.F / 100;
      Tvalue = mbtiCalculator.T / 100;
      Jvalue = mbtiCalculator.J / 100;
      Pvalue = mbtiCalculator.P / 100;
      MBTI = MBTI;
    });
  }
  @override
  void initState() {
    super.initState();
    dataLoading = getAll();
  }

  Widget build(BuildContext context) {

  return FutureBuilder(
  future: dataLoading,
  builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.done) {
    print("mbti : $MBTI");
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text('I', style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple
            ),),
            Container(
              width: 300,
              child: Slider(
                value: Evalue == 0 ? 1 - Ivalue : Evalue,
                onChanged: null,
              ),
            ),
            Text('E', style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),),
          ],
        ),
        //E,I 비율
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text('S', style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple
            ),),
            Container(
              width: 300,
              child: Slider(
                value: Nvalue == 0 ? 1 - Svalue : Nvalue,
                onChanged: null,
              ),
            ),
            Text('N', style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),),
          ],
        ),
        //S,N 비율
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text('T', style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple
            ),),
            Container(
              width: 300,
              child: Slider(
                value: Fvalue == 0 ? 1 - Tvalue : Fvalue,
                onChanged: null,
              ),
            ),
            Text('F', style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),),
          ],
        ),
        //T,F 비율
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text('P', style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple
            ),),
            Container(
              width: 300,
              child: Slider(
                value: Jvalue == 0 ? 1 - Pvalue : Jvalue,
                onChanged: null,
              ),
            ),
            Text('J', style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),),

          ],
        ),
        Text(MBTI!,
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 40,
          ),
        ),
      ],
    );
  }
  else{
    return CircularProgressIndicator();}
    },
  );
  }
}