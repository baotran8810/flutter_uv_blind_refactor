// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_speech_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSpeechResponseDto _$GetSpeechResponseDtoFromJson(
        Map<String, dynamic> json) =>
    GetSpeechResponseDto(
      status: json['status'] as String,
      data: GetSpeechDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetSpeechResponseDtoToJson(
        GetSpeechResponseDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

GetSpeechDto _$GetSpeechDtoFromJson(Map<String, dynamic> json) => GetSpeechDto(
      mp3Stream: Mp3Stream.fromJson(json['mp3Stream'] as Map<String, dynamic>),
      source: $enumDecode(_$SpeechSourceEnumMap, json['soundType']),
    );

Map<String, dynamic> _$GetSpeechDtoToJson(GetSpeechDto instance) =>
    <String, dynamic>{
      'mp3Stream': instance.mp3Stream.toJson(),
      'soundType': _$SpeechSourceEnumMap[instance.source],
    };

const _$SpeechSourceEnumMap = {
  SpeechSource.db: 'db',
  SpeechSource.polly: 'polly',
};

Mp3Stream _$Mp3StreamFromJson(Map<String, dynamic> json) => Mp3Stream(
      data: (json['data'] as List<dynamic>).map((e) => e as int).toList(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$Mp3StreamToJson(Mp3Stream instance) => <String, dynamic>{
      'data': instance.data,
      'type': instance.type,
    };
