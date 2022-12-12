import 'package:json_annotation/json_annotation.dart';

part 'language_dto.g.dart';

@JsonSerializable()
class LanguageDto {
  LanguageDto({
    required this.jpName,
    required this.enName,
    required this.langKey,
  });

  final String jpName;
  final String enName;
  final String langKey;

  factory LanguageDto.fromJson(Map<String, dynamic> json) =>
      _$LanguageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageDtoToJson(this);
}
