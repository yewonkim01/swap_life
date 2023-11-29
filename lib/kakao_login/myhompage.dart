import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'login.dart';
import 'package:swap_life/kakao_login/mainview.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final viewModel = MainViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              //login 안 된 상태
              if(!snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:const EdgeInsets.fromLTRB(0,50,0,300),
                      child: Container(
                        child: Image.asset("assets/swap_Life.jpg"),
                      ),
                    ),
                  Padding(padding: const EdgeInsets.fromLTRB(0,0,0,100),
                    child:
                    InkWell(
                      onTap: () async {
                        await viewModel.login();
                        setState(() {});
                      },
                      child: Container(
                        child: Image.asset('assets/kakao_login_pic.png'),
                      ),
                    ),
                  ),
                    Text("선녕원"),
                    Text("version 1.0.0"),
                  ]
                );
              }
              return MyHome();
            }
        ),
      ),
    );
  }
}