import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  /// Contructor
  const TodoEntity({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.isImportant,
    required this.createdAt,
    this.description,
    this.completedAt,
  });

  /// id
  final int id;

  /// title
  final String title;

  /// description
  final String? description;

  /// completed status
  final bool isCompleted;

  /// importancy status
  final bool isImportant;

  /// created time
  final DateTime createdAt;

  /// updated time
  final DateTime? completedAt;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        isCompleted,
        isImportant,
        createdAt,
        completedAt,
      ];
}
