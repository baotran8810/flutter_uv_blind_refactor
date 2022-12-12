import 'package:flutter_uv_blind_refactor/data_access/dtos/api_response_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_like_count_response_dto.g.dart';

@JsonSerializable()
class NotificationLikeCountResponseDto
    extends ApiResponseDto<LikeCountResponseDataDto> {
  const NotificationLikeCountResponseDto({
    required String status,
    required LikeCountResponseDataDto data,
  }) : super(
          status: status,
          data: data,
        );

  factory NotificationLikeCountResponseDto.fromJson(
          Map<String, dynamic> json) =>
      _$NotificationLikeCountResponseDtoFromJson(json);
  Map<String, dynamic> toJson() =>
      _$NotificationLikeCountResponseDtoToJson(this);
}

@JsonSerializable()
class LikeCountResponseDataDto {
  final int count;

  const LikeCountResponseDataDto({
    required this.count,
  });

  factory LikeCountResponseDataDto.fromJson(Map<String, dynamic> json) =>
      _$LikeCountResponseDataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LikeCountResponseDataDtoToJson(this);
}
