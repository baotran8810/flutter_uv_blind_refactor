// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_scan_code_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOnlineDocScanCodeResponseDto _$GetOnlineDocScanCodeResponseDtoFromJson(
        Map<String, dynamic> json) =>
    GetOnlineDocScanCodeResponseDto(
      status: json['status'] as String?,
      data: json['data'] == null
          ? null
          : OnlineDocScanCodeDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetOnlineDocScanCodeResponseDtoToJson(
        GetOnlineDocScanCodeResponseDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data?.toJson(),
    };

OnlineDocScanCodeDto _$OnlineDocScanCodeDtoFromJson(
        Map<String, dynamic> json) =>
    OnlineDocScanCodeDto(
      title: json['title'] as String?,
      previewQrcode: json['previewQrcode'] as String?,
      previewPoints: json['previewPoints'] as String?,
      codes: (json['codes'] as List<dynamic>?)
          ?.map((e) => OnlineCodeTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      codeType: json['codeType'] as String?,
      status: json['status'] as String?,
      ispublic: json['ispublic'] as bool?,
      publicDate: json['publicDate'] as String?,
      symSize: json['symSize'] as int?,
      symEcLevel: json['symEcLevel'] as int?,
      requestId: json['requestId'] as String?,
      imageURL: json['imageURL'] as String?,
      linkURL: json['linkURL'] as String?,
      fullContentURL: json['fullContentURL'] as String?,
      categoryId: json['categoryId'] as int?,
      settingOptions: json['settingOptions'] == null
          ? null
          : OnlineDocScanCodeSettingOptionsDto.fromJson(
              json['settingOptions'] as Map<String, dynamic>),
      id: json['id'] as int?,
      companyId: json['companyId'] as int?,
      projectId: json['projectId'] as int?,
      created: json['created'] as String?,
      modified: json['modified'] as String?,
      billId: json['billId'] as int?,
      category: json['category'] == null
          ? null
          : OnlineDocScanCodeCategoryDto.fromJson(
              json['category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OnlineDocScanCodeDtoToJson(
        OnlineDocScanCodeDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'previewQrcode': instance.previewQrcode,
      'previewPoints': instance.previewPoints,
      'codes': instance.codes?.map((e) => e.toJson()).toList(),
      'codeType': instance.codeType,
      'status': instance.status,
      'ispublic': instance.ispublic,
      'publicDate': instance.publicDate,
      'symSize': instance.symSize,
      'symEcLevel': instance.symEcLevel,
      'requestId': instance.requestId,
      'imageURL': instance.imageURL,
      'linkURL': instance.linkURL,
      'fullContentURL': instance.fullContentURL,
      'categoryId': instance.categoryId,
      'settingOptions': instance.settingOptions?.toJson(),
      'id': instance.id,
      'companyId': instance.companyId,
      'projectId': instance.projectId,
      'created': instance.created,
      'modified': instance.modified,
      'billId': instance.billId,
      'category': instance.category?.toJson(),
    };

OnlineCodeTag _$OnlineCodeTagFromJson(Map<String, dynamic> json) =>
    OnlineCodeTag(
      lang: json['lang'] as String?,
      text: json['text'] as String?,
      id: json['id'] as String?,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$OnlineCodeTagToJson(OnlineCodeTag instance) =>
    <String, dynamic>{
      'lang': instance.lang,
      'text': instance.text,
      'id': instance.id,
      'category': instance.category,
    };

OnlineDocScanCodeSettingOptionsDto _$OnlineDocScanCodeSettingOptionsDtoFromJson(
        Map<String, dynamic> json) =>
    OnlineDocScanCodeSettingOptionsDto(
      showTitle: json['showTitle'] as bool?,
      showBorder: json['showBorder'] as bool?,
      showBgcolor: json['showBgcolor'] as bool?,
      bgcolor: json['bgcolor'] as String?,
      fontcolor: json['fontcolor'] as String?,
    );

Map<String, dynamic> _$OnlineDocScanCodeSettingOptionsDtoToJson(
        OnlineDocScanCodeSettingOptionsDto instance) =>
    <String, dynamic>{
      'showTitle': instance.showTitle,
      'showBorder': instance.showBorder,
      'showBgcolor': instance.showBgcolor,
      'bgcolor': instance.bgcolor,
      'fontcolor': instance.fontcolor,
    };

OnlineDocScanCodeCategoryDto _$OnlineDocScanCodeCategoryDtoFromJson(
        Map<String, dynamic> json) =>
    OnlineDocScanCodeCategoryDto(
      name: json['name'] as String?,
      isLeaf: json['isLeaf'] as bool?,
      parent: json['parent'] as int?,
      orderBy: (json['orderBy'] as num?)?.toDouble(),
      id: json['id'] as int?,
      projectId: json['projectId'] as int?,
      created: json['created'] as String?,
      modified: json['modified'] as String?,
    );

Map<String, dynamic> _$OnlineDocScanCodeCategoryDtoToJson(
        OnlineDocScanCodeCategoryDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'isLeaf': instance.isLeaf,
      'parent': instance.parent,
      'orderBy': instance.orderBy,
      'id': instance.id,
      'projectId': instance.projectId,
      'created': instance.created,
      'modified': instance.modified,
    };
