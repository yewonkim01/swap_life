import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:swap_life/kakao_login/firebase_options.dart';
import 'package:swap_life/kakao_login/myhompage.dart';
import 'dart:core';
import 'MyProfile.dart';
import 'TodoScreen.dart';

void main() async {
  KakaoSdk.init(nativeAppKey: 'e7a7bba0f8d93f336d1343d3f47222ae',
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options : DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  const MyApp({Key? key}) : super(key:key);

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swap Life',
      theme: ThemeData(primaryColor: Colors.blueGrey[200]),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/myHome': (context) => MyHome(),
        '/myProfile' : (context) => MyProfile(),
        '/todo': (context) => TodoScreen(),
      },
      debugShowCheckedModeBanner: false,
    );//상태값 변하므로 Stateful위젯 사용
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      bodyWidget = tabContainer(context, Colors.white, "Friend's List");
    } else if(_selectedIndex == 1) {
      bodyWidget = TodoScreen();
    } else {
      bodyWidget= MyProfile();
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
      body : bodyWidget,
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