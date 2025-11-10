import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_web/entity/todo.dart';
import 'package:todo_web/todo_datasource.dart';

final homeScreenNotifierProvider =
    AsyncNotifierProvider<HomeScreenNotifier, List<Todo>>(
      HomeScreenNotifier.new,
    );

class HomeScreenNotifier extends AsyncNotifier<List<Todo>> {
  final _todoDataSource = TodoDataSource();

  Future<void> _fetchAndSetState() async {
    state = await AsyncValue.guard(() => _todoDataSource.getAllTodo());
  }

  @override
  Future<List<Todo>> build() async {
    return await _todoDataSource.getAllTodo();
  }

  Future<void> addTodo(String title, String description) async {
    state = AsyncValue.loading();
    await AsyncValue.guard(() => _todoDataSource.addTodo(title, description));
    _fetchAndSetState();
  }

  Future<void> deleteTodo(Todo todo) async {
    state = AsyncValue.loading();
    await AsyncValue.guard(() => _todoDataSource.deleteTodo(todo));
    _fetchAndSetState();
  }

  Future<void> updateTodo(Todo todo) async {
    state = AsyncValue.loading();
    await AsyncValue.guard(() => _todoDataSource.updateTodo(todo));
    _fetchAndSetState();
  }

  Future<void> editTodo(Todo todo, String title, String description) async {
    state = AsyncValue.loading();
    await AsyncValue.guard(() {
      todo.title = title;
      todo.description = description;
      return todo.save();
    });
    _fetchAndSetState();
  }
}
