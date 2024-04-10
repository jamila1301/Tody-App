part of 'todo_actions_bloc.dart';

abstract class TodoActionEvent extends Equatable {
  const TodoActionEvent();

  @override
  List<Object?> get props => [];
}

class TodoDeleteRequested extends TodoActionEvent {
  const TodoDeleteRequested(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class MarkAsCompletedRequested extends TodoActionEvent {
  const MarkAsCompletedRequested(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class MarkAsImportantRequested extends TodoActionEvent {
  const MarkAsImportantRequested(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}
