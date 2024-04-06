import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tody_app/core/bloc/data_state.dart';
import 'package:equatable/equatable.dart';
import 'package:tody_app/core/exception/empty_data_exception.dart';
import 'package:tody_app/data/model/error_response.dart';
import 'package:tody_app/features/todo/domain/entity/todo_entity.dart';
import 'package:tody_app/features/todo/domain/repository/todo_repository.dart';

part 'todo_list_event.dart';

typedef TodoListState = DataState<List<TodoEntity>>;

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc(this.todoRepository) : super(const InitialState()) {
    on<TodoListRequested>(_handleTodoListRequest);
  }

  final TodoRepository todoRepository;

  void _handleTodoListRequest(
    TodoListRequested event,
    Emitter<DataState<List<TodoEntity>>> emit,
  ) async {
    try {
      emit(const InProgressState());
      await Future.delayed(const Duration(seconds: 2));
      final todoList = await todoRepository.getTodoList(event.categoryId);

      emit(SuccessState(todoList));
    } on EmptyDataException catch (e) {
      print('EmptyDataException: $e');
      emit(const EmptyDataState());
    } on ErrorResponse catch (error) {
      print('ErrorResponse: $error');
      emit(FailureState(error.message));
    } catch (_) {
      print('$_');
      emit(const FailureState('Something went wrong!'));
    }
  }
}
