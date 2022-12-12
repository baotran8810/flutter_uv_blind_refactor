// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationRequestDto _$NotificationRequestDtoFromJson(
        Map<String, dynamic> json) =>
    NotificationRequestDto(
      limit: json['limit'] as int?,
      skip: json['skip'] as int?,
      order: json['order'] as String?,
      filter: NotifRequestFilterDto.fromJson(
          json['filter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationRequestDtoToJson(
        NotificationRequestDto instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'skip': instance.skip,
      'order': instance.order,
      'filter': instance.filter.toJson(),
    };

NotifRequestFilterDto _$NotifRequestFilterDtoFromJson(
        Map<String, dynamic> json) =>
    NotifRequestFilterDto(
      target: json['target'] as String,
      prefecture: json['prefecture'] as int?,
      city: json['city'] as String?,
      ward: json['ward'] as String?,
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      from:
          json['from'] == null ? null : DateTime.parse(json['from'] as String),
    );

Map<String, dynamic> _$NotifRequestFilterDtoToJson(
        NotifRequestFilterDto instance) =>
    <String, dynamic>{
      'target': instance.target,
      'prefecture': instance.prefecture,
      'city': instance.city,
      'ward': instance.ward,
      'gender': instance.gender,
      'age': instance.age,
      'from': instance.from?.toIso8601String(),
    };
