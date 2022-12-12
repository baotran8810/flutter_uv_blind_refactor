// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_speech_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSpeechRequestDto _$GetSpeechRequestDtoFromJson(Map<String, dynamic> json) =>
    GetSpeechRequestDto(
      keyword: json['keyword'] as String?,
      sentence: json['sentence'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      langKey: json['language'] as String,
      options:
          SpeechReqOptionsDto.fromJson(json['options'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetSpeechRequestDtoToJson(
        GetSpeechRequestDto instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'sentence': instance.sentence,
      'gender': _$GenderEnumMap[instance.gender],
      'language': instance.langKey,
      'options': instance.options.toJson(),
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
};

SpeechReqOptionsDto _$SpeechReqOptionsDtoFromJson(Map<String, dynamic> json) =>
    SpeechReqOptionsDto(
      pitchPercent: (json['pitch'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SpeechReqOptionsDtoToJson(
        SpeechReqOptionsDto instance) =>
    <String, dynamic>{
      'pitch': instance.pitchPercent,
    };
