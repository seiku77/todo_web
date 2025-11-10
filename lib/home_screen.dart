import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_web/home_screen_notifier.dart';
import 'package:todo_web/upsert_todo_dialog.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(homeScreenNotifierProvider);
    final notifier = ref.read(homeScreenNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Center(
        child: todos.when(
          data: (todos) {
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];

                return ListTile(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => UpsertTodoDialog(
                      title: 'Edit Todo',
                      submitButtonText: 'Save',
                      initialTodo: todo,
                      onSubmit: (title, description) {
                        notifier.editTodo(todo, title, description);
                      },
                    ),
                  ),
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                  leading: Checkbox(
                    value: todo.isDone,
                    onChanged: (value) => notifier.updateTodo(todo),
                  ),
                  trailing: IconButton(
                    onPressed: () => notifier.deleteTodo(todo),
                    icon: const Icon(Icons.close),
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => UpsertTodoDialog(
            title: 'Add Todo',
            submitButtonText: 'Add',
            onSubmit: (title, description) {
              notifier.addTodo(title, description);
            },
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
