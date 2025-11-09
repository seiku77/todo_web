import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_web/entity/todo.dart';
import 'package:todo_web/todo_datasource.dart';

final homeScreenNotifierProvider =
    NotifierProvider<HomeScreenNotifier, List<Todo>>(HomeScreenNotifier.new);

class HomeScreenNotifier extends Notifier<List<Todo>> {
  final _todoDataSource = TodoDataSource();

  @override
  List<Todo> build() {
    return _todoDataSource.getAllTodo() ??
        [Todo(title: "title", description: "description")];
  }

  Future<void> addTodo(String title, String description) async {
    await _todoDataSource.addTodo(title, description);
    state = _todoDataSource.getAllTodo() ?? [];
  }

  Future<void> deleteTodo(Todo todo) async {
    await _todoDataSource.deleteTodo(todo);
    state = _todoDataSource.getAllTodo() ?? [];
  }

  Future<void> updateTodo(Todo todo) async {
    await _todoDataSource.updateTodo(todo);
    state = _todoDataSource.getAllTodo() ?? [];
  }

  Future<void> editTodo(Todo todo, String title, String description) async {
    todo.title = title;
    todo.description = description;
    await todo.save();
    state = _todoDataSource.getAllTodo() ?? [];
  }
}
