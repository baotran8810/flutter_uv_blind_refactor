import 'package:json_annotation/json_annotation.dart';

part 'like_notification_request_dto.g.dart';

@JsonSerializable()
class LikeNotificationRequestDto {
  @JsonKey(name: 'user_id')
  final String? userId;

  @JsonKey(name: 'message_id')
  final int notificationId;

  @JsonKey(name: 'lat')
  final String latitude;

  @JsonKey(name: 'lon')
  final String longitude;

  final String? countryCode;
  final String? prefecture;
  final String? city;
  final String? ward;

  const LikeNotificationRequestDto({
    required this.userId,
    required this.notificationId,
    required this.latitude,
    required this.longitude,
    required this.countryCode,
    required this.prefecture,
    required this.city,
    required this.ward,
  });

  factory LikeNotificationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LikeNotificationRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LikeNotificationRequestDtoToJson(this);
}
