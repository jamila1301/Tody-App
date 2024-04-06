import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tody_app/core/bloc/data_state.dart';
import 'package:tody_app/core/theme/theme_ext.dart';
import 'package:tody_app/features/todo/domain/entity/todo_entity.dart';
import 'package:tody_app/features/todo/presentation/bloc/todo_list_bloc.dart';
import 'package:tody_app/features/todo/presentation/views/todo_item.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoListBloc, TodoListState>(
      builder: (context, state) {
        if (state is InProgressState) {
          return Center(
            child: Text(
              'Loading...',
              style: context.typography.titleMedium.copyWith(
                color: context.colors.onPrimary,
              ),
            ),
          );
        }

        if (state is SuccessState<List<TodoEntity>>) {
          final todoList = state.data;

          return Scrollbar(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 5),
              itemBuilder: (context, index) {
                return TodoItem(todo: todoList[index]);
              },
              itemCount: todoList.length,
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
