import 'package:equatable/equatable.dart';
import 'package:tody_app/features/todo/domain/entity/todo_entity.dart';

class TodoGroupEntity extends Equatable {
  const TodoGroupEntity({
    required this.categoryId,
    required this.compeletedTasks,
    required this.inCompletedTasks,
  });

  final int categoryId;
  final List<TodoEntity> compeletedTasks;
  final List<TodoEntity> inCompletedTasks;

  @override
  List<Object?> get props => [categoryId, compeletedTasks, inCompletedTasks];
}
