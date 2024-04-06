import 'package:tody_app/features/todo/data/data_source/todo_remote_data_source.dart';
import 'package:tody_app/features/todo/data/mapper/todo_mapper.dart';
import 'package:tody_app/features/todo/domain/entity/todo_entity.dart';
import 'package:tody_app/features/todo/domain/repository/todo_repository.dart';

final class TodoRepositoryImpl implements TodoRepository {
  const TodoRepositoryImpl(this.dataSource);

  final TodoRemoteDataSource dataSource;

  @override
  Future<List<TodoEntity>> getTodoList(int categoryId) async {
    final result = await dataSource.getTodoList(categoryId);
    return TodoMapper.toEntityList(result);
  }
}
