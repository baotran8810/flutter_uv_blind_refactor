// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_notification_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeNotificationRequestDto _$LikeNotificationRequestDtoFromJson(
        Map<String, dynamic> json) =>
    LikeNotificationRequestDto(
      userId: json['user_id'] as String?,
      notificationId: json['message_id'] as int,
      latitude: json['lat'] as String,
      longitude: json['lon'] as String,
      countryCode: json['countryCode'] as String?,
      prefecture: json['prefecture'] as String?,
      city: json['city'] as String?,
      ward: json['ward'] as String?,
    );

Map<String, dynamic> _$LikeNotificationRequestDtoToJson(
        LikeNotificationRequestDto instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'message_id': instance.notificationId,
      'lat': instance.latitude,
      'lon': instance.longitude,
      'countryCode': instance.countryCode,
      'prefecture': instance.prefecture,
      'city': instance.city,
      'ward': instance.ward,
    };
