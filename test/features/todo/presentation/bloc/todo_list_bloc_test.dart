import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tody_app/core/bloc/data_state.dart';
import 'package:tody_app/core/exception/empty_data_exception.dart';
import 'package:tody_app/data/model/error_response.dart';
import 'package:tody_app/features/todo/domain/entity/todo_entity.dart';
import 'package:tody_app/features/todo/domain/repository/todo_repository.dart';
import 'package:tody_app/features/todo/presentation/bloc/todo_list_bloc.dart';

import '../../../mock_list.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

typedef TodoListEntity = List<TodoEntity>;

void main() {
  late MockTodoRepository repository;

  setUpAll(() {
    repository = MockTodoRepository();
  });

  group(
    'TodoListBloc',
    () {
      blocTest(
        'should emit SucceessState when repository returns response',
        build: () => TodoListBloc(repository),
        act: (bloc) => bloc.add(const TodoListRequested(1)),
        setUp: () {
          when(() => repository.getTodoList(any())).thenAnswer(
            (invocation) async => mockTodoEntityList,
          );
        },
        expect: () => [
          const InProgressState<TodoListEntity>(),
          SuccessState(mockTodoEntityList),
        ],
        verify: (bloc) {
          verify(() => repository.getTodoList(1)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );

      blocTest(
        'should emit EmptyDataState when repository returns [EmptyDataException]',
        build: () => TodoListBloc(repository),
        act: (bloc) => bloc.add(const TodoListRequested(1)),
        setUp: () {
          when(() => repository.getTodoList(any())).thenThrow(
            const EmptyDataException(),
          );
        },
        expect: () => [
          const InProgressState<TodoListEntity>(),
          const EmptyDataState<TodoListEntity>(),
        ],
        verify: (bloc) {
          verify(() => repository.getTodoList(1)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );

      blocTest(
        'should emit [FailureState] with message '
        ' when repository returns [ErrorResponse]',
        build: () => TodoListBloc(repository),
        act: (bloc) => bloc.add(const TodoListRequested(1)),
        setUp: () {
          when(() => repository.getTodoList(any())).thenThrow(
            const ErrorResponse(
              statusCode: 404,
              message: 'Not Found!',
            ),
          );
        },
        expect: () => [
          const InProgressState<TodoListEntity>(),
          const FailureState<TodoListEntity>('Not Found!'),
        ],
        verify: (bloc) {
          verify(() => repository.getTodoList(1)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );
}
