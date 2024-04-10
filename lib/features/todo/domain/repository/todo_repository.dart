import 'package:tody_app/features/todo/domain/entity/todo_group_entity.dart';

abstract interface class TodoRepository {
  Future<TodoGroupEntity> getTodoList(int categoryId);
  Future<void> delete(int id);
  Future<void> markAsCompleted(int id);
  Future<void> markAsImportant(int id);
}
