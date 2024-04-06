import 'package:flutter/material.dart';
import 'package:tody_app/core/theme/theme_ext.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(16, 10, 24, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(28, 27, 31, 0.16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.add,
            color: context.colors.onPrimary,
          ),
          const SizedBox(width: 8),
          Text(
            'Add a task',
            style: context.typography.labelLarge.copyWith(
              color: context.colors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
