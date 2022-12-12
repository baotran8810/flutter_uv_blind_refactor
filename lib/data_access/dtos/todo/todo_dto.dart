import 'package:json_annotation/json_annotation.dart';

part 'todo_dto.g.dart';

@JsonSerializable()
class TodoDto {
  final int? id;
  final int? userId;
  final String? title;
  final bool? completed;

  TodoDto({
    this.id,
    this.userId,
    this.title,
    this.completed,
  });

  factory TodoDto.fromJson(Map<String, dynamic> json) =>
      _$TodoDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoDtoToJson(this);

  // factory TodoDto.fromEntity(TodoEntity entity) {
  //   return TodoDto(
  //     id: int.tryParse(entity.id),
  //     userId: entity.userId,
  //     title: entity.title,
  //     completed: entity.completed,
  //   );
  // }

  // TodoEntity toEntity() {
  //   return TodoEntity(
  //     id: id.toString(),
  //     userId: userId,
  //     title: title,
  //     completed: completed,
  //   );
  // }
}
