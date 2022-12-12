// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_like_count_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationLikeCountResponseDto _$NotificationLikeCountResponseDtoFromJson(
        Map<String, dynamic> json) =>
    NotificationLikeCountResponseDto(
      status: json['status'] as String,
      data: LikeCountResponseDataDto.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationLikeCountResponseDtoToJson(
        NotificationLikeCountResponseDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

LikeCountResponseDataDto _$LikeCountResponseDataDtoFromJson(
        Map<String, dynamic> json) =>
    LikeCountResponseDataDto(
      count: json['count'] as int,
    );

Map<String, dynamic> _$LikeCountResponseDataDtoToJson(
        LikeCountResponseDataDto instance) =>
    <String, dynamic>{
      'count': instance.count,
    };
