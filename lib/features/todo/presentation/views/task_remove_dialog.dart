import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tody_app/core/theme/theme_ext.dart';
import 'package:tody_app/features/todo/presentation/bloc/todo_actions_bloc.dart';
import 'package:tody_app/features/todo/presentation/bloc/todo_list_bloc.dart';
import 'package:tody_app/presentation/widgets/app_action_button.dart';
import 'package:tody_app/shared/widgets/app_base_dialog.dart';

class TaskRemoveDialog extends StatelessWidget {
  const TaskRemoveDialog({
    super.key,
    required this.id,
  });

  final int id;

  static Future<T?> show<T>({
    required BuildContext context,
    required int id,
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<TodoListBloc>(),
          ),
          BlocProvider.value(
            value: context.read<TodoActionsBloc>(),
          ),
        ],
        child: TaskRemoveDialog(id: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TodoActionsBloc, TodoActionState>(
      // listenWhen: (_, current) {
      //   return current is CategoryDeleteActionSuccess ||
      //       current is CategoryDeleteFailure;
      // },
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: AppBaseDialog(
        title: 'Are you sure?',
        body: Text(
          'Task will be permanently deleted',
          style: context.typography.bodyLarge.copyWith(
            color: context.colors.onSurfaceLowBrush,
          ),
        ),
        action: BlocBuilder<TodoActionsBloc, TodoActionState>(
          builder: (context, state) {
            if (state.isInProgress) {
              return const CircularProgressIndicator.adaptive();
            }

            return AppActionButton(
              widthFactor: WidthFactor.sized,
              color: context.colors.error,
              title: 'Delete',
              onPressed: () {
                context.read<TodoActionsBloc>().add(TodoDeleteRequested(id));
              },
            );
          },
        ),
      ),
    );
  }
}
