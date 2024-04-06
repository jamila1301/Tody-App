import 'package:flutter/material.dart';
import 'package:tody_app/core/theme/theme_ext.dart';
import 'package:tody_app/features/todo/presentation/views/add_task_button.dart';
import 'package:tody_app/features/todo/presentation/views/tast_list_view.dart';

class TodoListView extends StatefulWidget {
  const TodoListView({super.key});

  @override
  State<TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final tabTextStyle = context.typography.labelLarge;

    return SafeArea(
      top: false,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              dividerHeight: 0,
              indicatorColor: context.colors.primaryVariantLight,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: tabTextStyle.copyWith(
                color: context.colors.primaryVariant,
              ),
              unselectedLabelColor: context.colors.onSurfaceLowBrush,
              tabs: const [
                Tab(
                  text: 'To do',
                  iconMargin: EdgeInsets.zero,
                ),
                Tab(
                  text: 'Completed',
                ),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  TaskListView(),
                  Center(child: Text('Completed')),
                ],
              ),
            ),
            const AddTaskButton(),
          ],
        ),
      ),
    );
  }
}
