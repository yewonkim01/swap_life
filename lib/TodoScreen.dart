import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/src/painting/image_provider.dart';
import 'dart:io';
import 'dart:core';
import 'package:swap_life/shared/todo_controller.dart';
import 'package:swap_life/friends/friendList.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

class TodoItem {
  String title; //todo 항목
  bool isCompleted;// 항목의 완료 상태
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
  List<TodoItem> todoList = [];
  TextEditingController textEditingController = TextEditingController();
  FocusNode fnode = FocusNode();
  int i=0; int isnull=0; String? selectedMBTI; kakao.User ? user;

  List<String> dropdownList = ['E','I','S','N','T','F','J','P'];
  String selectedItem = 'E';

  CollectionReference userChecklistCollection(String userId) {
    return firestore.collection("checklist").doc(userId).collection("user_checklist");
  }

  Future<void> saveList() async {
    final checkList = firestore;
    String userId = user!.id.toString();

    await checkList.collection("checklist").doc(userId).collection("user_checklist").add({
      "MyChecklist$i": todoList[i].title,
      "MBTI": todoList[i].mbti,
    });

    i++;
  }

  Future<void> deleteList(index) async {
    final checkList = firestore;
    String userId = user!.id.toString();

    await checkList.collection("checklist").doc(userId).collection("user_checklist").doc(index.toString()).delete();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      getList();
    });
  }

  Future<void> getList() async {
    user = await kakao.UserApi.instance.me();
    final checkList = firestore;
    String userId = user!.id.toString();

    userChecklistCollection(userId).snapshots().listen((snapshot) {
      setState(() {
        todoList = snapshot.docs.map<TodoItem>((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          return TodoItem(
            title: data['MyChecklist$i'],
            mbti: data['MBTI'],
            isCompleted: false,
          );
        }).toList();
      });
    });
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
          Text("My checklist", style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold),),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
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
                      onSubmitted: (value){
                        setState(() {
                          todoList[i].title=value;
                        });}
                  ),
                ),
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
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    addTodoItem(
                        textEditingController.text, selectedItem.toString());
                    if (isnull == 0) {
                      saveList();
                      textEditingController.clear();
                    }
                    isnull = 0;
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child:ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.deepPurple,
                    value: todoList[index].isCompleted,
                    onChanged: (value) {
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
                        onPressed: () {
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