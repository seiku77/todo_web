import 'package:flutter/material.dart';
import 'package:todo_web/entity/todo.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:todo_web/hive_registrar.g.dart';
import 'dart:math';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapters();
  await Hive.openBox<Todo>('todos');

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainApp();
}

class _MainApp extends State<MainApp> {
  final todoBox = Hive.box<Todo>('todos');
  final todoWord = ['wow', 'read', 'apple', 'banana'];

  void addTodo() async {
    final random = Random();
    int randomIndex = random.nextInt(todoWord.length);
    String randomWord = todoWord[randomIndex];

    final newTodo = Todo(title: randomWord, description: 'test', isDone: false);
    await todoBox.add(newTodo);
    setState(() {});
  }

  void deleteTodo(Todo todo) async {
    await todo.delete();
    setState(() {});
  }

  void updateTodo(Todo todo) async {
    todo.isDone = !todo.isDone;
    await todo.save();
    setState(() {});
  }

  List<Todo>? getAllTodo() {
    return todoBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final todos = getAllTodo();

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ListView.builder(
            itemCount: todos?.length,
            itemBuilder: (context, index) {
              final todo = todos![index];

              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.description),
                leading: Checkbox(
                  value: todo.isDone,
                  onChanged: (value) => updateTodo(todo),
                ),
                trailing: IconButton(
                  onPressed: () => deleteTodo(todo),
                  icon: Icon(Icons.close),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addTodo,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
