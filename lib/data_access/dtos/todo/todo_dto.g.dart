// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoDto _$TodoDtoFromJson(Map<String, dynamic> json) => TodoDto(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      title: json['title'] as String?,
      completed: json['completed'] as bool?,
    );

Map<String, dynamic> _$TodoDtoToJson(TodoDto instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'completed': instance.completed,
    };
