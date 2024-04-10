import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tody_app/core/theme/theme_ext.dart';
import 'package:tody_app/core/utils/extensions/context_ext.dart';
import 'package:tody_app/features/todo/domain/entity/todo_entity.dart';
import 'package:tody_app/features/todo/presentation/bloc/todo_actions_bloc.dart';
import 'package:tody_app/features/todo/presentation/views/task_remove_dialog.dart';

class TodoItem extends StatefulWidget {
  const TodoItem({
    super.key,
    required this.todo,
  });

  final TodoEntity todo;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  var _itemRadius = BorderRadius.circular(10);

  @override
  Widget build(BuildContext context) {
    final importantIcon = widget.todo.isImportant
        ? Icons.star_outlined
        : Icons.star_outline_outlined;

    final importantColor = widget.todo.isImportant
        ? context.colors.error
        : context.colors.onSurfaceLowBrush;

    return Dismissible(
      key: ValueKey(widget.todo.id),
      direction: DismissDirection.endToStart,
      background: const SizedBox.shrink(),
      dismissThresholds: const {
        DismissDirection.endToStart: 0.3,
      },
      onDismissed: (direction) {
        print('dismissed: $direction');
      },
      secondaryBackground: Container(
        padding: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: context.colors.error,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete_outline,
          size: 24,
        ),
      ),
      onUpdate: (details) {
        print('update: $details');
        setState(() {
          if (details.progress == 0) {
            _itemRadius = BorderRadius.circular(10);
          } else {
            _itemRadius = const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            );
          }
        });
      },
      confirmDismiss: (direction) async {
        TaskRemoveDialog.show(
          context: context,
          id: widget.todo.id,
        );
        return false;
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: _itemRadius,
          color: context.colors.surface,
        ),
        child: Row(
          children: [
            Checkbox(
              value: widget.todo.isCompleted,
              onChanged: (_) {
                context.read<TodoActionsBloc>().add(
                      MarkAsCompletedRequested(
                        widget.todo.id,
                      ),
                    );
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.todo.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.titleMedium.copyWith(
                      color: context.colors.onSurface,
                    ),
                  ),
                  Text(
                    context.l10n.formattedDate(widget.todo.createdAt),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.bodyMedium.copyWith(
                      color: context.colors.onSurfaceMediumBrush,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () {
                context.read<TodoActionsBloc>().add(
                      MarkAsImportantRequested(
                        widget.todo.id,
                      ),
                    );
              },
              icon: Icon(
                importantIcon,
                color: importantColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
