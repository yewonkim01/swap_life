import 'package:flutter/material.dart';
import 'package:flutter/src/material/page.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'dart:core';
import 'MyProfile.dart';
import 'package:swap_life/show_login.dart';

FocusNode fnode=new FocusNode();

void main() {
  KakaoSdk.init(nativeAppKey: 'e7a7bba0f8d93f336d1343d3f47222ae',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swap Life',
      theme: ThemeData(primaryColor: Colors.blueGrey[200]),
      initialRoute: '/',
      routes: {
        '/': (context) => ShowLogin(),
        '/myHome': (context) => MyHome(),
        '/myProfile' : (context) => MyProfile(),
        TodoScreen.routeName: (context) => TodoScreen(),
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
        iconTheme: IconThemeData(color: Colors.green),
        title: Text("Swap Life"),
        centerTitle: true,
        backgroundColor:Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.0,
      ),
      bottomNavigationBar: TabBar(
        indicatorColor: Colors.green,
        labelColor: Colors.black,
        overlayColor: MaterialStatePropertyAll(Colors.white70),
        controller: _tabController,
        tabs: <Tab>[
          Tab(
            icon: Icon(
              _selectedIndex == 0 ? Icons.swap_horizontal_circle : Icons.swap_horizontal_circle_outlined,
              color: Colors.green,
            ),
            text: "Friend",
          ),
            Tab(
              icon: Icon(
              _selectedIndex == 1 ? Icons.home : Icons.home_outlined,
                color: Colors.green,
              ),
          text: "Home",
            ),
          Tab(
            icon: Icon(
              _selectedIndex == 2 ? Icons.person : Icons.person_outline,
              color: Colors.green,
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

class TodoItem {
  String title; // 할 일 항목의 제목
  bool isCompleted;// 할 일 항목의 완료 상태

  TodoItem({required this.title, this.isCompleted = false});
}

class TodoScreen extends StatefulWidget {
  static const routeName = '/todo';
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<TodoItem> todoList = [];
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Checklist"),
        centerTitle: true,
        backgroundColor:Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: fnode,
                    controller: textEditingController,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(labelText: "Add a new task",labelStyle:TextStyle(color:fnode.hasFocus? Colors.green : Colors.grey),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)))  ,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    addTodoItem(textEditingController.text);
                    textEditingController.clear();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.green,
                    value: todoList[index].isCompleted,
                    onChanged: (value) {
                      toggleTodoItem(index);
                    },
                  ),
                  title: Text(todoList[index].title),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteTodoItem(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void addTodoItem(String title) {
    setState(() {
      todoList.add(TodoItem(title: title, isCompleted: false));
    });
  }

  void deleteTodoItem(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  void toggleTodoItem(int index) {
    setState(() {
      todoList[index].isCompleted = !todoList[index].isCompleted;
    });
  }
}

