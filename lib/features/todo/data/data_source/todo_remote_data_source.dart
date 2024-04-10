import 'dart:io';

import 'package:tody_app/core/exception/data_not_found_exception.dart';
import 'package:tody_app/core/exception/empty_data_exception.dart';
import 'package:tody_app/core/exception/general_exception.dart';
import 'package:tody_app/core/rest/rest_client.dart';
import 'package:tody_app/data/model/error_response.dart';
import 'package:tody_app/features/todo/data/model/todo_model.dart';

abstract interface class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodoList(int categoryId);
  Future<void> delete(int id);
  Future<void> markAsCompleted(int id);
  Future<void> markAsImportant(int id);
}

final class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  const TodoRemoteDataSourceImpl(this.client);

  final RestClient client;

  @override
  Future<List<TodoModel>> getTodoList(int categoryId) async {
    final response = await client.get(
      '/todo',
      queryParameters: {
        'category_id': categoryId,
      },
    );
    final data = response.data as List<dynamic>;

    if (data.isEmpty) {
      throw const EmptyDataException();
    }

    return data.map((category) => TodoModel.fromJson(category)).toList();
  }

  @override
  Future<void> delete(int id) async {
    try {
      await client.delete('/todo/$id');
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        throw DataNotFoundException(e.message);
      }

      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        GeneralException(e.toString()),
        stackTrace,
      );
    }
  }

  @override
  Future<void> markAsCompleted(int id) async {
    try {
      await client.patch('/todo/$id/complete');
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        GeneralException(e.toString()),
        stackTrace,
      );
    }
  }

  @override
  Future<void> markAsImportant(int id) async {
    try {
      await client.patch('/todo/$id/important');
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        GeneralException(e.toString()),
        stackTrace,
      );
    }
  }
}
