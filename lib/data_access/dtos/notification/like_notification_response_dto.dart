import 'package:flutter_uv_blind_refactor/data_access/dtos/api_response_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'like_notification_response_dto.g.dart';

@JsonSerializable()
class LikeNotificationResponseDto extends ApiResponseDto<LikeResponseDataDto> {
  const LikeNotificationResponseDto({
    required String status,
    required LikeResponseDataDto data,
  }) : super(
          status: status,
          data: data,
        );

  factory LikeNotificationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LikeNotificationResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LikeNotificationResponseDtoToJson(this);
}

@JsonSerializable()
class LikeResponseDataDto {
  @JsonKey(name: 'uuid')
  final String id;

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

  LikeResponseDataDto({
    required this.id,
    required this.userId,
    required this.notificationId,
    required this.latitude,
    required this.longitude,
    required this.countryCode,
    required this.prefecture,
    required this.city,
    required this.ward,
  });

  factory LikeResponseDataDto.fromJson(Map<String, dynamic> json) =>
      _$LikeResponseDataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LikeResponseDataDtoToJson(this);
}
