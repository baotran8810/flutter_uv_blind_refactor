// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_notification_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeNotificationResponseDto _$LikeNotificationResponseDtoFromJson(
        Map<String, dynamic> json) =>
    LikeNotificationResponseDto(
      status: json['status'] as String,
      data: LikeResponseDataDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LikeNotificationResponseDtoToJson(
        LikeNotificationResponseDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

LikeResponseDataDto _$LikeResponseDataDtoFromJson(Map<String, dynamic> json) =>
    LikeResponseDataDto(
      id: json['uuid'] as String,
      userId: json['user_id'] as String?,
      notificationId: json['message_id'] as int,
      latitude: json['lat'] as String,
      longitude: json['lon'] as String,
      countryCode: json['countryCode'] as String?,
      prefecture: json['prefecture'] as String?,
      city: json['city'] as String?,
      ward: json['ward'] as String?,
    );

Map<String, dynamic> _$LikeResponseDataDtoToJson(
        LikeResponseDataDto instance) =>
    <String, dynamic>{
      'uuid': instance.id,
      'user_id': instance.userId,
      'message_id': instance.notificationId,
      'lat': instance.latitude,
      'lon': instance.longitude,
      'countryCode': instance.countryCode,
      'prefecture': instance.prefecture,
      'city': instance.city,
      'ward': instance.ward,
    };
