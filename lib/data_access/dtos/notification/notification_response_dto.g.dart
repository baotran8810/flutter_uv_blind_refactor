// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationResponseDto _$NotificationResponseDtoFromJson(
        Map<String, dynamic> json) =>
    NotificationResponseDto(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => NotificationDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotificationResponseDtoToJson(
        NotificationResponseDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };
