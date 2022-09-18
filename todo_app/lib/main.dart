import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:todo_app/state/todo_model.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'package:todo_app/screens/todo_form.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoModel(),
      child: const TodoListApp(),
    ),
  );
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo list',
      initialRoute: '/',
      // flutter routes allow quick navgation with a built in back button
      routes: {
        '/entry': (context) => TodoForm(),
        '/': (context) => TodoScreen(),
      }, // This trailing comma makes auto-formatting nicer for build methods.
    ); // MaterialApp
  }
}
