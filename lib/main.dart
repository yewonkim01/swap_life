import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:swap_life/kakao_login/firebase_options.dart';
import 'package:swap_life/kakao_login/myhompage.dart';
import 'dart:core';
import 'MyProfile.dart';
import 'TodoScreen.dart';
import 'firestore/service.dart';
import 'shared/shared.dart';
import 'FriendScreen.dart';
import 'package:swap_life/shared/todo_controller.dart';
import 'package:swap_life/friends/dynamicLink.dart';



void main() async{
  var services = HttpServices();
  var controller = TodoController(services);
  KakaoSdk.init(
      nativeAppKey: 'e7a7bba0f8d93f336d1343d3f47222ae',
      javaScriptAppKey: 'dc58af574c1d9b2e8e2a27485a830ecf14f59171');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options : DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(controller: controller));
}



//예선 작성//
class MyApp extends StatelessWidget {
  final TodoController controller;
  MyApp({required this.controller});

  @override
  Widget build(BuildContext context) {

    DynamicLink(controller, context).initDynamicLink(context);

    return MaterialApp(
      title: 'Swap Life',
      theme: ThemeData(primaryColor: Colors.blueGrey[200]),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(controller: controller),
        '/myHome': (context) => MyHome(controller: controller),
        '/myProfile' : (context) => MyProfile(),
        '/todoScreen': (context) => TodoScreen(controller: controller),
        '/friendScreen': (context) => FriendPage(controller: controller),
      },
      debugShowCheckedModeBanner: false,

    );//상태값 변하므로 Stateful위젯 사용
  }
}

//예선 작성//
class MyHome extends StatefulWidget {
  final TodoController controller;
  MyHome({required this.controller});

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {

  TabController? _tabController;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    //앱 초기 실행시 프로필로 바꿨을 때 tabcontroller도 바꿔줌(예원)
    _tabController!.index = 2;
    _tabController!.addListener(() {
      setState(() {
        _selectedIndex = _tabController!.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;
    if(_selectedIndex==0) {
      //추후 친구 chech list받아오는 함수 연결
      //bodyWidget = tabContainer(context, Colors.white, "Friend's List");
      bodyWidget = FriendPage(controller: widget.controller,);
      }
    else if(_selectedIndex == 1) {
      //bodyWidget = FriendPage(controller: widget.controller);
      bodyWidget = TodoScreen(controller: widget.controller);
    }
    else {
      bodyWidget = MyProfile();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {},icon: Icon(Icons.cloud_outlined)),
        iconTheme: IconThemeData(color: Colors.deepPurple),
        title: Text("Swap Life"),
        centerTitle: true,
        backgroundColor:Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: bodyWidget,
      bottomNavigationBar: TabBar(
        indicatorColor: Colors.deepPurple,
        labelColor: Colors.black,
        overlayColor: MaterialStatePropertyAll(Colors.white70),
        controller: _tabController,
        tabs: <Tab>[
          Tab(
            icon: Icon(
              _selectedIndex == 0 ? Icons.swap_horizontal_circle : Icons.swap_horizontal_circle_outlined,
              color: Colors.deepPurple,
            ),
            text: "Friend",
          ),
          Tab(
            icon: Icon(
              _selectedIndex == 1 ? Icons.home : Icons.home_outlined,
              color: Colors.deepPurple,
            ),
            text: "Home",
          ),
          Tab(
            icon: Icon(
              _selectedIndex == 2 ? Icons.person : Icons.person_outline,
              color: Colors.deepPurple,
            ),
            text: "Profile",
          ),
        ],
      ),
    );
  }

  Container tabContainer(BuildContext context, Color tabColor, String tabText) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: tabColor,
      child: Center(
        child: Text(
          tabText,
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}