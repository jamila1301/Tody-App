import 'package:tody_app/features/todo/domain/entity/todo_entity.dart';

abstract interface class TodoRepository {
  Future<List<TodoEntity>> getTodoList(int categoryId);
}
