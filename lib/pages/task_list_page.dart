import 'package:flutter/material.dart';
import 'package:tody_app/core/theme/theme_ext.dart';
import 'package:tody_app/features/category/presentation/views/category_actions_header.dart';
import 'package:tody_app/features/todo/presentation/views/todo_list_view.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({
    super.key,
    required this.categoryId,
  });

  final int categoryId;

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.primaryVariantLight,
      body: Column(
        children: [
          CategoryActionsHeader(categoryId: widget.categoryId),
          const Expanded(child: TodoListView()),
        ],
      ),
    );
  }
}
