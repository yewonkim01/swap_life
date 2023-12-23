import 'package:flutter/material.dart';

class myMBTIreport extends StatefulWidget{
  @override
  myMBTIreportState createState() => myMBTIreportState();
}

class myMBTIreportState extends State<myMBTIreport> {

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
}