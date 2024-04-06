import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tody_app/core/theme/theme_ext.dart';
import 'package:tody_app/core/utils/extensions/context_ext.dart';
import 'package:tody_app/features/todo/domain/entity/todo_entity.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.todo,
  });

  final TodoEntity todo;

  @override
  Widget build(BuildContext context) {
    final importantIcon =
        todo.isImportant ? Icons.star_outlined : Icons.star_outline_outlined;

    final importantColor = todo.isImportant
        ? context.colors.error
        : context.colors.onSurfaceLowBrush;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.colors.surface,
      ),
      child: Row(
        children: [
          Checkbox(
            value: todo.isCompleted,
            onChanged: (_) {},
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typography.titleMedium.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),
                Text(
                  context.l10n.formattedDate(todo.createdAt),
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
          Icon(
            importantIcon,
            color: importantColor,
          ),
        ],
      ),
    );
  }
}
