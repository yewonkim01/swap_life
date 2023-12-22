//김진영 작성

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swap_life/calc_mbti.dart';

class calc_mbti extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> _calc_mbit();
}

class _calc_mbit extends State<calc_mbti>{

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SliderWidget(),
        ],
      ),
    );
  }
}

class SliderWidget extends StatefulWidget{
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget>{
  double Evalue = 0;
  double Nvalue = 0;
  double Fvalue = 0;
  double Jvalue = 0;
  String? MBTI = '';

  void getAll(){
    getList mbtiCalculator = getList();
    mbtiCalculator.getProfile();
    mbtiCalculator.processList();
    mbtiCalculator.finalMBTI();
    Evalue = mbtiCalculator.E / 100;
    Nvalue = mbtiCalculator.N / 100;
    Fvalue = mbtiCalculator.F / 100;
    Jvalue = mbtiCalculator.J / 100;
  }


  Widget build(BuildContext context){
    getAll();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text('I',style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple
            ),),
            Container(
            width: 300,
              child: Slider(
                value: Evalue,
                onChanged: null,
              ),
            ),
            Text('E',style : TextStyle(
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
            const Text('S',style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple
            ),),
            Container(
              width: 300,
              child: Slider(
                value: Nvalue,
                onChanged: null,
              ),
            ),
            Text('N',style : TextStyle(
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
            const Text('T',style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple
            ),),
            Container(
              width: 300,
              child: Slider(
                value: Fvalue,
                onChanged: null,
              ),
            ),
            Text('F',style : TextStyle(
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
            const Text('P',style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple
            ),),
            Container(
              width: 300,
              child: Slider(
                value: Jvalue,
                onChanged: null,
              ),
            ),
            Text('J',style : TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),),
          ],
        ),
      ],
    );
  }
}