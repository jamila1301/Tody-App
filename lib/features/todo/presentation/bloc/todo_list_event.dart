part of 'todo_list_bloc.dart';

abstract class TodoListEvent extends Equatable {
  const TodoListEvent();

  @override
  List<Object?> get props => [];
}

class TodoListRequested extends TodoListEvent {
  const TodoListRequested(this.categoryId);

  final int categoryId;

  @override
  List<Object?> get props => [categoryId];
}

class RefreshListRequested extends TodoListEvent {
  const RefreshListRequested();
}
