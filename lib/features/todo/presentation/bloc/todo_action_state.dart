part of 'todo_actions_bloc.dart';

enum ActionSuccessType { delete, complete, important }

class TodoActionState extends Equatable {
  const TodoActionState({
    this.isInProgress = false,
    this.isFailure = false,
    this.isSuccess = false,
    this.errorMessage,
    this.actionSuccessType,
  });

  final bool isInProgress;
  final bool isFailure;
  final bool isSuccess;
  final String? errorMessage;
  final ActionSuccessType? actionSuccessType;

  TodoActionState copyWith({
    final bool? isInProgress,
    final bool? isFailure,
    final bool? isSuccess,
    final String? errorMessage,
    final ActionSuccessType? actionSuccessType,
  }) {
    return TodoActionState(
      isInProgress: isInProgress ?? false,
      isFailure: isFailure ?? false,
      isSuccess: isSuccess ?? false,
      errorMessage: errorMessage,
      actionSuccessType: actionSuccessType,
    );
  }

  @override
  List<Object?> get props => [
        isInProgress,
        isFailure,
        isSuccess,
        errorMessage,
        actionSuccessType,
      ];
}
