import 'package:flutter_uv_blind_refactor/data_access/dtos/api_response_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'unlike_notification_response_dto.g.dart';

@JsonSerializable()
class UnlikeNotificationResponseDto
    extends ApiResponseDto<Map<String, dynamic>> {
  const UnlikeNotificationResponseDto({
    required String status,
    required Map<String, dynamic> data,
  }) : super(
          status: status,
          data: data,
        );

  factory UnlikeNotificationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$UnlikeNotificationResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UnlikeNotificationResponseDtoToJson(this);
}

@JsonSerializable()
class UnlikeResponseDataDto {
  final String count;

  const UnlikeResponseDataDto({
    required this.count,
  });

  factory UnlikeResponseDataDto.fromJson(Map<String, dynamic> json) =>
      _$UnlikeResponseDataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UnlikeResponseDataDtoToJson(this);
}
