import 'package:equatable/equatable.dart';

abstract class DataState<T> extends Equatable {
  const DataState();

  @override
  List<Object?> get props => [];
}

class InitialState<T> extends DataState<T> {
  const InitialState();
}

class InProgressState<T> extends DataState<T> {
  const InProgressState();
}

class FailureState<T> extends DataState<T> {
  const FailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class EmptyDataState<T> extends DataState<T> {
  const EmptyDataState();
}

class SuccessState<T> extends DataState<T> {
  const SuccessState(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}
