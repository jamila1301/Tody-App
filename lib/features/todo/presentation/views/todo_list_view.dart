import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tody_app/core/bloc/data_state.dart';
import 'package:tody_app/core/theme/theme_ext.dart';
import 'package:tody_app/features/todo/domain/entity/todo_group_entity.dart';
import 'package:tody_app/features/todo/presentation/bloc/todo_actions_bloc.dart';
import 'package:tody_app/features/todo/presentation/bloc/todo_list_bloc.dart';
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

    return BlocListener<TodoActionsBloc, TodoActionState>(
      listener: (context, state) {
        if (state.isFailure) {
          final message = state.errorMessage ?? 'Error happened!';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
        } else if (state.isSuccess) {
          final message = switch (state.actionSuccessType) {
            ActionSuccessType.delete => 'Todo deleted successfully!',
            ActionSuccessType.important =>
              'Todo marked as important successfully!',
            ActionSuccessType.complete => 'Todo completed successfully!',
            _ => 'N/A',
          };

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );

          context.read<TodoListBloc>().add(const RefreshListRequested());
        }
      },
      child: SafeArea(
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
              Expanded(
                child: BlocBuilder<TodoListBloc, TodoListState>(
                  builder: (context, state) {
                    final loadingView = Center(
                      child: Text(
                        'Loading...',
                        style: context.typography.titleMedium.copyWith(
                          color: context.colors.onPrimary,
                        ),
                      ),
                    );

                    return TabBarView(
                      children: [
                        if (state is InProgressState) ...[
                          loadingView,
                          loadingView,
                        ] else if (state is SuccessState<TodoGroupEntity>) ...[
                          TaskListView(tasks: state.data.inCompletedTasks),
                          TaskListView(tasks: state.data.compeletedTasks),
                        ] else ...[
                          const SizedBox.shrink(),
                          const SizedBox.shrink(),
                        ],
                      ],
                    );
                  },
                ),
              ),
              const AddTaskButton(),
            ],
          ),
        ),
      ),
    );
  }
}
