import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swap_life/login.dart';

class ShowLogin extends StatelessWidget{
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Image.asset("assets/kakao_login_pic.png"),
          onPressed: () => signInWithKakao(),
        ),
      ),
    );
  }
}