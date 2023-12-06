import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:swap_life/shared/todo_controller.dart';
import 'package:swap_life/friends/friendList.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

List<TodoItem> todoList = [];

//Todo list에 들어갈 항목,mbti,완료상태
class TodoItem {
  String title;
  bool isCompleted; //기본값 false -> 항목을 완료하지 않음
  String mbti;
  TodoItem({required this.title, required this.mbti, this.isCompleted = false});

  void changeMBTI(String mbti){
    this.mbti = mbti;
  }
}

class TodoScreen extends StatefulWidget {
  final TodoController controller;
  TodoScreen({required this.controller});
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  TextEditingController textEditingController = TextEditingController();
  FocusNode fnode = FocusNode();
  int i=0; int isnull=0; String? selectedMBTI; kakao.User ? user;

  //Dropdown에서 쓸 MBTI 선택지 list
  List<String> dropdownList = ['E','I','S','N','T','F','J','P'];
  String selectedItem = 'E'; //기본값=null 상황을 방지하기 위한 초기값

  //초기에 사용자ID=null 상황을 방지하기 위해 userId받아오는 함수
  Future<String> getOrCreateDefaultUserId() async {
    kakao.User? user = await kakao.UserApi.instance.me();
    String userId = user?.id.toString() ?? 'defaultUserID';
    // Firestore에서 해당 사용자 ID가 있는지 확인
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    DocumentSnapshot userSnapshot = await userRef.get();

    if (!userSnapshot.exists) {
      // 사용자 ID가 Firestore에 없으면 새로운 ID 생성
      await userRef.set({'createdAt': FieldValue.serverTimestamp()});
    }
    return userId;
  }

  //firestore에 유저 checkList 저장하는 함수
  Future<void> saveList() async {
    try {
      final checkList = firestore;
      String userId = user?.id.toString() ?? await getOrCreateDefaultUserId();
      DocumentReference Ref = checkList.collection('checklist').doc(userId);

      List<Map<String, dynamic>> existingItems = [];
      DocumentSnapshot snapshot = await Ref.get();

      if (snapshot.exists) {
        dynamic data = snapshot.data();
        if (data != null && data['user_checklist'] != null) {
          existingItems = List<Map<String, dynamic>>.from(
            (data['user_checklist'] as List<dynamic>)
                .map((item) => Map<String, dynamic>.from(item)),
          );
        }
      }
      existingItems.add({
        'title': todoList.last.title,
        'mbti': todoList.last.mbti,
      });

      await Ref.set({'user_checklist': existingItems});
    } catch (e) {
      print("Error saving list: $e");
    }
  }

  //에뮬레이터 화면 상에 삭제된 checkList를 firestore상에서도 삭제하는 함수
  Future<void> deleteList(int index) async {
    final checkList = firestore;
    String userId =user?.id.toString() ?? await getOrCreateDefaultUserId();
    DocumentReference Ref = checkList.collection('checklist').doc(userId);
    DocumentSnapshot snapshot = await Ref.get();

    if (snapshot.exists) {
      dynamic data = snapshot.data();
      if (data != null && data['user_checklist'] != null) {
        List<Map<String, dynamic>> existingItems = List<Map<String, dynamic>>.from(
          (data['user_checklist'] as List<dynamic>)
              .map((item) => Map<String, dynamic>.from(item)),
        );

        if (index >= 0 && index < existingItems.length) {
          existingItems.removeAt(index);
          await Ref.update({'user_checklist': existingItems});
        }
      }
    }
  }

  //함수 실행 시, 자동으로 getList() 실행시켜주는 함수
  @override
  void initState() {
    getList();
    super.initState();
  }
  //화면 전환 및 종료시에도 checkList 유지
  Future<void> getList() async {
      final checkList = firestore;
      String userId = user?.id.toString() ?? await getOrCreateDefaultUserId();
      user = await kakao.UserApi.instance.me();

      if(userId != null) {
        DocumentSnapshot snapshot = await checkList.collection('checklist').doc(userId).get();
        Map<String, dynamic>? data = snapshot.data() as Map<String,dynamic>?;
        if (data != null) {
          setState(() {
            todoList = List<TodoItem>.from(data['user_checklist'].map(
                  (item) => TodoItem(
                title: item['title'],
                mbti: item['mbti'],
               // isCompleted: item['isCompleted'],
              ),
            ));
          });
          print(todoList);
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text("My Checklist"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),*/
      body: Column(
        children: [
          SizedBox(height: 10),

          FriendList(widget.controller, context),

          SizedBox(height: 35),
          //checkList
          Text("My checklist", style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold),),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  //checkList입력하는 TextField
                  child: TextField(
                      focusNode: fnode,
                      controller: textEditingController,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        labelText: "Add a new task",
                        labelStyle: TextStyle(
                          color: fnode.hasFocus ? Colors.deepPurple : Colors.grey,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      onChanged: (value){
                        setState(() {});}
                  ),
                ),
                //MBTI 선택할 수 있는 버튼
                DropdownButton<String?>(
                  focusNode: fnode,
                  hint: Text('MBTI'),
                  onChanged: (dynamic newVal) {
                    setState(() {
                      selectedItem = newVal;
                    });
                  },
                  value: selectedItem,
                  items: ['E', 'I', 'S', 'N', 'T', 'F', 'J', 'P'].map<
                      DropdownMenuItem<String?>>((String i) {
                    return DropdownMenuItem<String>(
                      value: i,
                      child: Text(i),
                    );
                  }).toList(),
                ),
                //checkList를 등록하는 버튼
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // todoList에 text,mbti,isconplete 값 add
                    addTodoItem(
                        textEditingController.text, selectedItem.toString());
                    // input값이 존재하면 firestore상에 add 및 TextField 초기화
                    if (isnull == 0) {
                      saveList();
                      textEditingController.clear();
                    }
                    // 1로 변경되었을 때를 대비해 다시 0으로 변경해주는 작업
                    isnull = 0;
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length, //text 좌우로 icon존재하기 때문에 길이 제한
              itemBuilder: (context, index) { // 선택한 index 따라 작업 진행
                return ListTile(
                  leading: Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.deepPurple,
                    value: todoList[index].isCompleted,
                    onChanged: (value) {
                      // checkBox상태 변경을 위한 bool 함수
                      toggleTodoItem(index);
                    },
                  ),
                  title: Text(
                    todoList[index].title,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        todoList[index].mbti.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      SizedBox(width: 16),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          deleteList(index);
                          deleteTodoItem(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  void addTodoItem(String title, String mbti) {
    setState(() {
      //공백 상태로 checkList 추가 불가
      if(title != null && title.trim().isNotEmpty) {
        todoList.add(TodoItem(title: title, mbti: mbti,isCompleted: false));
      } else{
        // input text=null이면, isnull=1로 지정해 add버튼 실행 시 saveList(),clear 작업 생략
        isnull = 1;
      }
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