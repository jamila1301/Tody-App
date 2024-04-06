import 'package:tody_app/features/todo/data/model/todo_model.dart';
import 'package:tody_app/features/todo/domain/entity/todo_entity.dart';

final mockTodoModelList = [
  TodoModel(
    id: 1,
    title: 'Test Title',
    isCompleted: false,
    isImportant: false,
    createdAt: DateTime.parse('2024-03-12T19:04:37.757207Z'),
  ),
];

final mockTodoEntityList = [
  TodoEntity(
    id: 1,
    title: 'Test Title',
    isCompleted: false,
    isImportant: false,
    createdAt: DateTime.parse('2024-03-12T19:04:37.757207Z'),
  ),
];
