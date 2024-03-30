import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class TodoModel extends Equatable {
  /// Contructor
  const TodoModel({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.isImportant,
    required this.createdAt,
    this.description,
    this.completedAt,
  });

  /// fromJson of User
  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

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

  /// toJson of User model
  Map<String, dynamic> toJson() => _$TodoModelToJson(this);

  @override
  List<Object?> get props => [id, title];
}
