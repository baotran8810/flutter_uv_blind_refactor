import 'package:json_annotation/json_annotation.dart';

part 'online_scan_code_dto.g.dart';

@JsonSerializable()
class GetOnlineDocScanCodeResponseDto {
  String? status;
  OnlineDocScanCodeDto? data;

  GetOnlineDocScanCodeResponseDto({this.status, this.data});

  factory GetOnlineDocScanCodeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GetOnlineDocScanCodeResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetOnlineDocScanCodeResponseDtoToJson(this);
}

@JsonSerializable()
class OnlineDocScanCodeDto {
  String? title;
  String? previewQrcode;
  String? previewPoints;
  List<OnlineCodeTag>? codes;
  String? codeType;
  String? status;
  bool? ispublic;
  String? publicDate;
  int? symSize;
  int? symEcLevel;
  String? requestId;
  String? imageURL;
  String? linkURL;
  String? fullContentURL;
  int? categoryId;
  OnlineDocScanCodeSettingOptionsDto? settingOptions;
  int? id;
  int? companyId;
  int? projectId;
  String? created;
  String? modified;
  int? billId;
  OnlineDocScanCodeCategoryDto? category;

  OnlineDocScanCodeDto({
    this.title,
    this.previewQrcode,
    this.previewPoints,
    this.codes,
    this.codeType,
    this.status,
    this.ispublic,
    this.publicDate,
    this.symSize,
    this.symEcLevel,
    this.requestId,
    this.imageURL,
    this.linkURL,
    this.fullContentURL,
    this.categoryId,
    this.settingOptions,
    this.id,
    this.companyId,
    this.projectId,
    this.created,
    this.modified,
    this.billId,
    this.category,
  });

  factory OnlineDocScanCodeDto.fromJson(Map<String, dynamic> json) =>
      _$OnlineDocScanCodeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineDocScanCodeDtoToJson(this);
}

@JsonSerializable()
class OnlineCodeTag {
  String? lang;
  String? text;
  String? id;
  String? category;

  OnlineCodeTag({this.lang, this.text, this.id, this.category});

  factory OnlineCodeTag.fromJson(Map<String, dynamic> json) =>
      _$OnlineCodeTagFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineCodeTagToJson(this);
}

@JsonSerializable()
class OnlineDocScanCodeSettingOptionsDto {
  bool? showTitle;
  bool? showBorder;
  bool? showBgcolor;
  String? bgcolor;
  String? fontcolor;

  OnlineDocScanCodeSettingOptionsDto({
    this.showTitle,
    this.showBorder,
    this.showBgcolor,
    this.bgcolor,
    this.fontcolor,
  });

  factory OnlineDocScanCodeSettingOptionsDto.fromJson(
          Map<String, dynamic> json) =>
      _$OnlineDocScanCodeSettingOptionsDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OnlineDocScanCodeSettingOptionsDtoToJson(this);
}

@JsonSerializable()
class OnlineDocScanCodeCategoryDto {
  String? name;
  bool? isLeaf;
  int? parent;
  double? orderBy;
  int? id;
  int? projectId;
  String? created;
  String? modified;

  OnlineDocScanCodeCategoryDto({
    this.name,
    this.isLeaf,
    this.parent,
    this.orderBy,
    this.id,
    this.projectId,
    this.created,
    this.modified,
  });

  factory OnlineDocScanCodeCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$OnlineDocScanCodeCategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineDocScanCodeCategoryDtoToJson(this);
}
