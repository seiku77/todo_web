import 'package:flutter/material.dart';
import 'package:todo_web/entity/todo.dart';

class UpsertTodoDialog extends StatefulWidget {
  final String title;
  final String submitButtonText;
  final Function(String title, String description) onSubmit;
  final Todo? initialTodo;

  const UpsertTodoDialog({
    super.key,
    required this.title,
    required this.submitButtonText,
    required this.onSubmit,
    this.initialTodo,
  });

  @override
  State<UpsertTodoDialog> createState() => _UpsertTodoDialogState();
}

class _UpsertTodoDialogState extends State<UpsertTodoDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialTodo?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialTodo?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_titleController.text, _descriptionController.text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) =>
                  value!.trim().isEmpty ? 'Please enter a title' : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) =>
                  value!.trim().isEmpty ? 'Please enter a description' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(widget.submitButtonText),
        ),
      ],
    );
  }
}
