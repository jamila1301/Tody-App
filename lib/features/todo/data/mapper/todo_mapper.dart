import 'package:tody_app/features/todo/data/model/todo_model.dart';
import 'package:tody_app/features/todo/domain/entity/todo_entity.dart';

abstract class TodoMapper {
  static TodoEntity toEntity(TodoModel model) {
    return TodoEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      isCompleted: model.isCompleted,
      isImportant: model.isImportant,
      createdAt: model.createdAt,
      completedAt: model.completedAt,
    );
  }

  static List<TodoEntity> toEntityList(List<TodoModel> todoList) {
    return todoList.map((todo) => TodoMapper.toEntity(todo)).toList();
  }
}
