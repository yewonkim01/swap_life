import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/src/painting/image_provider.dart';
import 'dart:io';
import 'dart:core';
import 'package:swap_life/shared/todo_controller.dart';

class TodoItem {
  String title; // 할 일 항목의 제목
  bool isCompleted;// 할 일 항목의 완료 상태

  TodoItem({required this.title, this.isCompleted = false});
}

class TodoScreen extends StatefulWidget {
  final TodoController controller;
  TodoScreen({required this.controller});
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  final List<TodoItem> todoList = [];
  TextEditingController textEditingController = TextEditingController();
  FocusNode fnode = FocusNode();
  int i=0; int isnull=0; String? selectedMBTI;

  void saveList() async {
    final checkList = firestore;
    bool _isnull=false;

    /*while(!_isnull) {
      if(todoList[i].title != null) {
        i++;
      } else {
          _isnull = true;
      }
    }*/
    await checkList.collection("checklist").add({"MyChecklist$i":todoList[i].title,"MBTI":selectedMBTI});
    i++;
  }

  void deleteList(index) async {
    final checkList = firestore;

    await checkList.collection("checklist").doc("MyChecklist${index}").delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Checklist"),
        centerTitle: true,
        backgroundColor:Colors.white,
        foregroundColor: Colors.black,
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
                    decoration: InputDecoration(
                        labelText: "Add a new task",
                        labelStyle:TextStyle(
                            color:fnode.hasFocus? Colors.deepPurple : Colors.grey),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepPurple
                            ),
                        ),
                    )  ,
                      onChanged: (value){
                        setState(() {
                          todoList[i].title=value;
                        });
                      }
                  ),
                ),
                DropdownButton<String?>(
                  hint: Text('MBTI'),
                  //button 활성화
                  onChanged: (String? newVal) {
                    setState(() {
                      selectedMBTI=newVal;
                    });
                  },
                  items: [
                    'E','I','S','N','T','F','J','P'
                  ].map<DropdownMenuItem<String?>>((String? i) {
                    return DropdownMenuItem<String?>(
                      value: i,
                      child:Text({'E':'E','I':'I','S':'S','N':'N','T':'T','F':'F','J':'J','P':'P'}[i] ?? ''),);
                  }).toList(),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    addTodoItem(textEditingController.text);
                    if(isnull==0) {
                      saveList();
                      textEditingController.clear();
                    }
                    isnull=0;
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
                    checkColor: Colors.deepPurple,
                    value: todoList[index].isCompleted,
                    onChanged: (value) {
                      toggleTodoItem(index);
                    },
                  ),
                  title: Text(todoList[index].title),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteList(index);
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
      if(title != null && title.trim().isNotEmpty) {
        todoList.add(TodoItem(title: title, isCompleted: false));
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