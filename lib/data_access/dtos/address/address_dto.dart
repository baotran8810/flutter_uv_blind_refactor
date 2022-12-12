import 'package:json_annotation/json_annotation.dart';

part 'address_dto.g.dart';

@JsonSerializable()
class AddressDto {
  AddressDto({
    required this.cityName,
    required this.isWard,
    required this.prefectureName,
    required this.tagData,
    required this.wardName,
  });

  final String cityName;
  final bool? isWard;
  final String prefectureName;
  final TagData tagData;
  final String? wardName;

  factory AddressDto.fromJson(Map<String, dynamic> json) =>
      _$AddressDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDtoToJson(this);

  String getAddressName() {
    return '$prefectureName - ${getCityAndWardName()}';
  }

  String getCityAndWardName() {
    return cityName +
        (wardName != "" && wardName != null ? ' - $wardName' : '');
  }
}

@JsonSerializable()
class TagData {
  TagData({
    required this.city,
    required this.prefecture,
    required this.ward,
  });

  final String city;
  final String prefecture;
  final String ward;

  factory TagData.fromJson(Map<String, dynamic> json) =>
      _$TagDataFromJson(json);

  Map<String, dynamic> toJson() => _$TagDataToJson(this);
}
