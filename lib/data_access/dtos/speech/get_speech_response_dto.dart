import 'package:flutter_uv_blind_refactor/data_access/dtos/api_response_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_speech_response_dto.g.dart';

@JsonSerializable()
class GetSpeechResponseDto extends ApiResponseDto<GetSpeechDto> {
  const GetSpeechResponseDto({
    required String status,
    required GetSpeechDto data,
  }) : super(
          status: status,
          data: data,
        );

  factory GetSpeechResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GetSpeechResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$GetSpeechResponseDtoToJson(this);
}

@JsonSerializable()
class GetSpeechDto {
  final Mp3Stream mp3Stream;

  @JsonKey(name: 'soundType')
  final SpeechSource source;

  const GetSpeechDto({
    required this.mp3Stream,
    required this.source,
  });

  factory GetSpeechDto.fromJson(Map<String, dynamic> json) =>
      _$GetSpeechDtoFromJson(json);
  Map<String, dynamic> toJson() => _$GetSpeechDtoToJson(this);
}

@JsonSerializable()
class Mp3Stream {
  final List<int> data;
  final String type;

  Mp3Stream({
    required this.data,
    required this.type,
  });

  factory Mp3Stream.fromJson(Map<String, dynamic> json) =>
      _$Mp3StreamFromJson(json);
  Map<String, dynamic> toJson() => _$Mp3StreamToJson(this);
}

enum SpeechSource {
  @JsonValue('db')
  db,
  @JsonValue('polly')
  polly,
}
