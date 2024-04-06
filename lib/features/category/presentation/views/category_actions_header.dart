import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tody_app/core/theme/theme_ext.dart';
import 'package:tody_app/features/category/presentation/bloc/category_actions/category_actions_bloc.dart';
import 'package:tody_app/features/category/presentation/views/category_remove_dialog.dart';
import 'package:tody_app/features/category/presentation/views/category_renaming_dialog.dart';

class CategoryActionsHeader extends StatefulWidget {
  const CategoryActionsHeader({
    super.key,
    required this.categoryId,
  });

  final int categoryId;

  @override
  State<CategoryActionsHeader> createState() => _CategoryActionsHeaderState();
}

class _CategoryActionsHeaderState extends State<CategoryActionsHeader> {
  @override
  void didUpdateWidget(covariant CategoryActionsHeader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.categoryId != widget.categoryId) {
      context.read<CategoryActionsBloc>().add(
            CategoryDetailsRequested(widget.categoryId),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryActionsBloc, CategoryActionsState>(
      buildWhen: (_, current) {
        return current is CategoryLaodingAction ||
            current is CategoryActionSuccess ||
            current is CategoryActionsFailure;
      },
      builder: (context, state) {
        final title = switch (state) {
          CategoryActionsInitial() => 'N/A',
          CategoryLaodingAction() => '...',
          CategoryActionSuccess(categoryEntity: var category) => category.title,
          _ => 'Failure!',
        };

        return AppBar(
          centerTitle: false,
          foregroundColor: context.colors.onPrimary,
          backgroundColor: context.colors.primaryVariantLight,
          title: Text(
            title,
            style: context.typography.titleLarge.copyWith(
              color: context.colors.onPrimary,
            ),
          ),
          actions: [
            if (state is CategoryActionSuccess)
              IconButton(
                color: context.colors.onPrimary,
                onPressed: () {
                  CategoryRenamingDialog.show(context);
                },
                icon: const Icon(Icons.drive_file_rename_outline),
              ),
            if (state is CategoryActionSuccess)
              IconButton(
                color: context.colors.onPrimary,
                onPressed: () {
                  CategoryRemoveDialog.show(context);
                },
                icon: const Icon(Icons.delete_outline),
              ),
          ],
        );
      },
    );
  }
}
