import 'package:tody_app/features/todo/data/model/todo_model.dart';
import 'package:tody_app/features/todo/domain/entity/todo_entity.dart';
import 'package:tody_app/features/todo/domain/entity/todo_group_entity.dart';

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

  static TodoGroupEntity toEntityList({
    required int categoryId,
    required List<TodoModel> todoList,
  }) {
    final completedTasks = <TodoEntity>[];
    final otherTasks = <TodoEntity>[];

    for (int i = 0; i < todoList.length; i++) {
      final todo = todoList[i];
      final todoEntity = TodoMapper.toEntity(todo);

      if (todoEntity.isCompleted) {
        completedTasks.add(todoEntity);
      } else {
        otherTasks.add(todoEntity);
      }
    }

    return TodoGroupEntity(
      categoryId: categoryId,
      compeletedTasks: completedTasks,
      inCompletedTasks: otherTasks,
    );
  }
}
