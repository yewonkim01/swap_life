import 'package:flutter/material.dart';
import 'dart:core';
import 'shared/shared.dart';

class TodoScreen extends StatefulWidget{
  final TodoController controller;
  const TodoScreen({Key? key, required this.controller}) : super(key:key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo>? todo;
  bool isLoading = false;

  void _getTodo() async {
    var newTodo = await widget.controller.fetchTodo();
    setState(() {
      todo = newTodo;
    });
  }

  void updateTodo(Todo todoItem, bool isCompleted) async {
    bool success = await widget.controller.updateTodo(todoItem, isCompleted);
    setState(() {
      if(!success) {
        todoItem.completed = !isCompleted;
      }
    });
  }

  void initState() {
    super.initState();
    widget.controller.onSync.listen((bool syncState) => setState(() {isLoading = syncState;}));
  }

  Widget get body => isLoading
      ? CircularProgressIndicator()
      : ListView.builder(
        key:Key('list-view'),
        itemCount: todo?.length ?? 1,
        itemBuilder: (ctx, idx) {
          if(todo != null ) {
            return CheckboxListTile(
              key: ValueKey("todo-$idx"),
              onChanged: (bool? val) => updateTodo(todo![idx], val!),
              value: todo![idx].completed,
              title: Text(todo![idx].title),
              subtitle: Text(
                "todo num: $idx",
                key: ValueKey("todo-$idx-subtitle"),
              ),
            );
          } else {
            return Text("Tap button to fetch todos");
          }
        }
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HTTP Todos'),
        actions: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                widget.controller.getCompletedTodo().toString(),
                key: ValueKey("counter"),
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          ),
        ],
      ),
      body: Center(child: body),
      floatingActionButton: FloatingActionButton(
        key: Key("get-todos-button"),
        onPressed: () => _getTodo(),
        child: Icon(Icons.add),
      ),
    );
  }
}