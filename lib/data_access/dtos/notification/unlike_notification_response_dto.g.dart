// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unlike_notification_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnlikeNotificationResponseDto _$UnlikeNotificationResponseDtoFromJson(
        Map<String, dynamic> json) =>
    UnlikeNotificationResponseDto(
      status: json['status'] as String,
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$UnlikeNotificationResponseDtoToJson(
        UnlikeNotificationResponseDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

UnlikeResponseDataDto _$UnlikeResponseDataDtoFromJson(
        Map<String, dynamic> json) =>
    UnlikeResponseDataDto(
      count: json['count'] as String,
    );

Map<String, dynamic> _$UnlikeResponseDataDtoToJson(
        UnlikeResponseDataDto instance) =>
    <String, dynamic>{
      'count': instance.count,
    };
