import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_speech_request_dto.g.dart';

@JsonSerializable()
class GetSpeechRequestDto {
  final String? keyword;
  final String sentence;
  final Gender gender;

  @JsonKey(name: 'language')
  final String langKey;

  final SpeechReqOptionsDto options;

  const GetSpeechRequestDto({
    required this.keyword,
    required this.sentence,
    required this.gender,
    required this.langKey,
    required this.options,
  });

  factory GetSpeechRequestDto.fromJson(Map<String, dynamic> json) =>
      _$GetSpeechRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$GetSpeechRequestDtoToJson(this);
}

@JsonSerializable()
class SpeechReqOptionsDto {
  @JsonKey(name: 'pitch')
  final double? pitchPercent;

  const SpeechReqOptionsDto({
    required this.pitchPercent,
  });

  factory SpeechReqOptionsDto.fromJson(Map<String, dynamic> json) =>
      _$SpeechReqOptionsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SpeechReqOptionsDtoToJson(this);
}
