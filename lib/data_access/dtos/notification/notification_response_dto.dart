import 'package:flutter_uv_blind_refactor/data_access/dtos/api_response_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notification_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_response_dto.g.dart';

@JsonSerializable()
class NotificationResponseDto extends ApiResponseDto<List<NotificationDto>> {
  const NotificationResponseDto({
    required String status,
    required List<NotificationDto> data,
  }) : super(
          status: status,
          data: data,
        );

  factory NotificationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationResponseDtoToJson(this);
}
