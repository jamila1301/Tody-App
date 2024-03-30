import 'package:tody_app/core/exception/empty_data_exception.dart';
import 'package:tody_app/core/exception/general_exception.dart';
import 'package:tody_app/core/rest/rest_client.dart';
import 'package:tody_app/data/model/error_response.dart';
import 'package:tody_app/features/todo/data/model/todo_model.dart';

abstract interface class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodoList(int categoryId);
}

// /// TDD - Test Driven Development

final class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  const TodoRemoteDataSourceImpl(this.client);

  final RestClient client;

  @override
  Future<List<TodoModel>> getTodoList(int categoryId) async {
    final response = await client.get('/todo?category_id=$categoryId');
    final data = response.data as List<dynamic>;

    if (data.isEmpty) {
      throw const EmptyDataException();
    }

    return data.map((category) => TodoModel.fromJson(category)).toList();
  }
}
