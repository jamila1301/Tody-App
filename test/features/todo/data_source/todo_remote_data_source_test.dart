import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tody_app/core/exception/empty_data_exception.dart';
import 'package:tody_app/core/rest/rest_client.dart';
import 'package:tody_app/data/model/error_response.dart';
import 'package:tody_app/features/todo/data/data_source/todo_remote_data_source.dart';
import 'package:tody_app/features/todo/data/model/todo_model.dart';

import '../../../json/json_reader.dart';

final _list = [
  TodoModel(
    id: 1,
    title: 'Test Title',
    isCompleted: false,
    isImportant: false,
    createdAt: DateTime.parse('2024-03-12T19:04:37.757207Z'),
  ),
];

class MockClient extends Mock implements RestClient {}

void main() {
  TodoRemoteDataSourceImpl? dataSource;
  RestClient? client;

  setUp(() {
    client = MockClient();
    dataSource = TodoRemoteDataSourceImpl(client!);
  });

  group(
    'getTodoList',
    () {
      test(
        'should return list of Todo',
        () async {
          when(() => client!.get(any())).thenAnswer(
            (_) async => ApiResponse(
              statusCode: 200,
              data: JsonFileReader.read('todo_list.json'),
            ),
          );

          final todoList = await dataSource!.getTodoList(1);

          expect(todoList, _list);
          verify(() => client!.get(any())).called(1);
          verifyNoMoreInteractions(client);
        },
      );

      test(
        'should throw EmptyDataException when there is no data in list of todo',
        () async {
          when(() => client!.get(any())).thenAnswer(
            (_) async => const ApiResponse(statusCode: 200, data: []),
          );

          expect(
            dataSource!.getTodoList(1),
            throwsA(isA<EmptyDataException>()),
          );

          verify(() => client!.get(any())).called(1);
          verifyNoMoreInteractions(client);
        },
      );

      test(
        'should throw ErrorResponse when the client failed',
        () async {
          when(() => client!.get(any())).thenThrow(
            const ErrorResponse(statusCode: 404, message: 'Not Found!'),
          );

          expect(
            dataSource!.getTodoList(1),
            throwsA(isA<ErrorResponse>()),
          );

          verify(() => client!.get(any())).called(1);
          verifyNoMoreInteractions(client);
        },
      );
    },
  );
}
