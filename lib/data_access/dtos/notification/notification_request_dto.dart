import 'package:json_annotation/json_annotation.dart';

part 'notification_request_dto.g.dart';

@JsonSerializable()
class NotificationRequestDto {
  final int? limit;
  final int? skip;
  final String? order;
  final NotifRequestFilterDto filter;

  const NotificationRequestDto({
    this.limit,
    this.skip,
    this.order,
    required this.filter,
  });

  factory NotificationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationRequestDtoToJson(this);
}

@JsonSerializable()
class NotifRequestFilterDto {
  final String target;
  final int? prefecture;
  final String? city;
  final String? ward;
  final String? gender;
  final int? age;
  final DateTime? from;

  const NotifRequestFilterDto({
    required this.target,
    required this.prefecture,
    required this.city,
    required this.ward,
    required this.gender,
    required this.age,
    required this.from,
  });

  factory NotifRequestFilterDto.fromJson(Map<String, dynamic> json) =>
      _$NotifRequestFilterDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NotifRequestFilterDtoToJson(this);
}
