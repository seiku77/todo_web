import 'package:hive_ce/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late bool isDone;

  Todo({required this.title, required this.description, this.isDone = false});
}
