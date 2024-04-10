import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tody_app/core/bloc/data_state.dart';
import 'package:tody_app/core/exception/empty_data_exception.dart';
import 'package:tody_app/data/model/error_response.dart';
import 'package:tody_app/features/todo/domain/entity/todo_group_entity.dart';
import 'package:tody_app/features/todo/domain/repository/todo_repository.dart';

part 'todo_list_event.dart';

typedef TodoListState = DataState<TodoGroupEntity>;

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc(this.todoRepository) : super(const InitialState()) {
    on<TodoListRequested>(_handleTodoListRequest);
    on<RefreshListRequested>(_handleRefreshRequest);
  }

  final TodoRepository todoRepository;

  void _handleTodoListRequest(
    TodoListRequested event,
    Emitter<TodoListState> emit,
  ) async {
    try {
      emit(const InProgressState());
      final todoList = await todoRepository.getTodoList(event.categoryId);

      emit(SuccessState(todoList));
    } on EmptyDataException catch (e) {
      emit(const EmptyDataState());
    } on ErrorResponse catch (error) {
      emit(FailureState(error.message));
    } catch (_) {
      emit(const FailureState('Something went wrong!'));
    }
  }

  void _handleRefreshRequest(
    RefreshListRequested event,
    Emitter<TodoListState> emit,
  ) {
    if (state is! SuccessState<TodoGroupEntity>) return;
    final categoryId = (state as SuccessState<TodoGroupEntity>).data.categoryId;
    add(TodoListRequested(categoryId));
  }
}
