import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tody_app/core/exception/data_not_found_exception.dart';
import 'package:tody_app/data/model/error_response.dart';
import 'package:tody_app/features/todo/domain/repository/todo_repository.dart';

part 'todo_action_event.dart';
part 'todo_action_state.dart';

class TodoActionsBloc extends Bloc<TodoActionEvent, TodoActionState> {
  TodoActionsBloc(this.todoRepository) : super(const TodoActionState()) {
    on<TodoDeleteRequested>(_deleteTodo);
    on<MarkAsCompletedRequested>(_markAsCompleted);
    on<MarkAsImportantRequested>(_markAsImportant);
  }

  final TodoRepository todoRepository;

  void _deleteTodo(
    TodoDeleteRequested event,
    Emitter<TodoActionState> emit,
  ) async {
    try {
      emit(state.copyWith(isInProgress: true));
      await todoRepository.delete(event.id);
      emit(
        state.copyWith(
          isSuccess: true,
          actionSuccessType: ActionSuccessType.delete,
        ),
      );
    } on DataNotFoundException catch (e) {
      emit(state.copyWith(isFailure: true, errorMessage: e.message));
    } on ErrorResponse catch (e) {
      emit(state.copyWith(isFailure: true, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isFailure: true, errorMessage: e.toString()));
    }
  }

  void _markAsCompleted(
    MarkAsCompletedRequested event,
    Emitter<TodoActionState> emit,
  ) async {
    try {
      emit(state.copyWith(isInProgress: true));
      await todoRepository.markAsCompleted(event.id);
      emit(
        state.copyWith(
          isSuccess: true,
          actionSuccessType: ActionSuccessType.complete,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isFailure: true, errorMessage: e.toString()));
    }
  }

  void _markAsImportant(
    MarkAsImportantRequested event,
    Emitter<TodoActionState> emit,
  ) async {
    try {
      emit(state.copyWith(isInProgress: true));
      await todoRepository.markAsImportant(event.id);
      emit(
        state.copyWith(
          isSuccess: true,
          actionSuccessType: ActionSuccessType.important,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isFailure: true, errorMessage: e.toString()));
    }
  }
}
