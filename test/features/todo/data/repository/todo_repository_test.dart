import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tody_app/data/model/error_response.dart';
import 'package:tody_app/features/todo/data/data_source/todo_remote_data_source.dart';
import 'package:tody_app/features/todo/data/repository/todo_repository_impl.dart';
import 'package:tody_app/features/todo/domain/repository/todo_repository.dart';

import '../../../mock_list.dart';

class MockTodoRemoteDataSource extends Mock implements TodoRemoteDataSource {}

void main() {
  late TodoRepository repository;
  late MockTodoRemoteDataSource dataSource;

  setUpAll(
    () {
      dataSource = MockTodoRemoteDataSource();
      repository = TodoRepositoryImpl(dataSource);
    },
  );

  group('getTodoList', () {
    test(
      'should return list of TodoEntity in success case',
      () async {
        /// stub
        when(() => dataSource.getTodoList(any())).thenAnswer(
          (invocation) async => mockTodoModelList,
        );

        final result = await repository.getTodoList(1);
        expect(result, mockTodoEntityList);

        verify(() => dataSource.getTodoList(1)).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    test(
      'should return ErrorResponse when API returns error status code',
      () async {
        const errorResponse = ErrorResponse(
          statusCode: 404,
          message: 'Not found',
        );

        when(() => dataSource.getTodoList(any())).thenThrow(errorResponse);

        expect(repository.getTodoList(1), throwsA(isA<ErrorResponse>()));

        verify(() => dataSource.getTodoList(1)).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );
  });
}
