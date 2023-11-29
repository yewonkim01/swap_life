import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/src/painting/image_provider.dart';
import 'dart:io';
import 'dart:core';

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
  FocusNode fnode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Checklist"),
        centerTitle: true,
        backgroundColor:Colors.deepPurple,
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
                    decoration: InputDecoration(labelText: "Add a new task",labelStyle:TextStyle(color:fnode.hasFocus? Colors.deepPurple : Colors.grey),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)))  ,
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
