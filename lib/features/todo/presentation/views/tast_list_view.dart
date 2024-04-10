import 'package:flutter/material.dart';
import 'package:tody_app/features/todo/domain/entity/todo_entity.dart';
import 'package:tody_app/features/todo/presentation/views/todo_item.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({
    super.key,
    required this.tasks,
  });

  final List<TodoEntity> tasks;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 5),
        itemBuilder: (context, index) {
          return TodoItem(todo: tasks[index]);
        },
        itemCount: tasks.length,
      ),
    );
  }
}
