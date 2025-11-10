import 'package:hive_ce/hive.dart';
import 'package:todo_web/entity/todo.dart';

class TodoDataSource {
  final _todoBox = Hive.box<Todo>('todos');

  Future<void> addTodo(String title, String description) async {
    final newTodo = Todo(title: title, description: description, isDone: false);
    await _todoBox.add(newTodo);
  }

  Future<void> deleteTodo(Todo todo) async {
    await todo.delete();
  }

  Future<void> updateTodo(Todo todo) async {
    todo.isDone = !todo.isDone;
    await todo.save();
  }

  Future<void> editTodo(Todo todo, String title, String description) async {
    todo.title = title;
    todo.description = description;
    await todo.save();
  }

  Future<List<Todo>> getAllTodo() async {
    return _todoBox.values.toList();
  }
}
