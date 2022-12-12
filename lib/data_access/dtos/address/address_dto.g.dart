// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressDto _$AddressDtoFromJson(Map<String, dynamic> json) => AddressDto(
      cityName: json['cityName'] as String,
      isWard: json['isWard'] as bool?,
      prefectureName: json['prefectureName'] as String,
      tagData: TagData.fromJson(json['tagData'] as Map<String, dynamic>),
      wardName: json['wardName'] as String?,
    );

Map<String, dynamic> _$AddressDtoToJson(AddressDto instance) =>
    <String, dynamic>{
      'cityName': instance.cityName,
      'isWard': instance.isWard,
      'prefectureName': instance.prefectureName,
      'tagData': instance.tagData.toJson(),
      'wardName': instance.wardName,
    };

TagData _$TagDataFromJson(Map<String, dynamic> json) => TagData(
      city: json['city'] as String,
      prefecture: json['prefecture'] as String,
      ward: json['ward'] as String,
    );

Map<String, dynamic> _$TagDataToJson(TagData instance) => <String, dynamic>{
      'city': instance.city,
      'prefecture': instance.prefecture,
      'ward': instance.ward,
    };
