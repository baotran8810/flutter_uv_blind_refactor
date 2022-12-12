// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationDto _$NotificationDtoFromJson(Map<String, dynamic> json) =>
    NotificationDto(
      id: json['id'] as int,
      companyId: json['company_id'] as int,
      localizedMessageList: (json['localized_messages'] as List<dynamic>?)
          ?.map((e) =>
              NotifLocalizedMessageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      webviewUrl: json['webview_url'] as String,
      qrCode: json['qrcode'] == null
          ? null
          : NotifQrCodeDto.fromJson(json['qrcode'] as Map<String, dynamic>),
      lastPushAt: DateTime.parse(json['last_push'] as String),
      likedCount: json['liked_count'] as int?,
      company: json['company'] == null
          ? null
          : NotifCompanyDto.fromJson(json['company'] as Map<String, dynamic>),
      attachmentList: (json['attachment'] as List<dynamic>?)
          ?.map((e) => NotifAttachmentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotificationDtoToJson(NotificationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'localized_messages':
          instance.localizedMessageList?.map((e) => e.toJson()).toList(),
      'webview_url': instance.webviewUrl,
      'qrcode': instance.qrCode?.toJson(),
      'last_push': instance.lastPushAt.toIso8601String(),
      'liked_count': instance.likedCount,
      'company': instance.company?.toJson(),
      'attachment': instance.attachmentList?.map((e) => e.toJson()).toList(),
    };

NotifLocalizedMessageDto _$NotifLocalizedMessageDtoFromJson(
        Map<String, dynamic> json) =>
    NotifLocalizedMessageDto(
      lang: json['lang'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$NotifLocalizedMessageDtoToJson(
        NotifLocalizedMessageDto instance) =>
    <String, dynamic>{
      'lang': instance.lang,
      'title': instance.title,
      'content': instance.content,
    };

NotifQrCodeDto _$NotifQrCodeDtoFromJson(Map<String, dynamic> json) =>
    NotifQrCodeDto(
      link: json['link'] as String,
    );

Map<String, dynamic> _$NotifQrCodeDtoToJson(NotifQrCodeDto instance) =>
    <String, dynamic>{
      'link': instance.link,
    };

NotifCompanyDto _$NotifCompanyDtoFromJson(Map<String, dynamic> json) =>
    NotifCompanyDto(
      id: json['id'] as int,
      companyName: json['company_name'] as String,
    );

Map<String, dynamic> _$NotifCompanyDtoToJson(NotifCompanyDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_name': instance.companyName,
    };

NotifAttachmentDto _$NotifAttachmentDtoFromJson(Map<String, dynamic> json) =>
    NotifAttachmentDto(
      type: $enumDecode(_$AttachmentTypeEnumMap, json['type']),
      url: json['url'] as String,
    );

Map<String, dynamic> _$NotifAttachmentDtoToJson(NotifAttachmentDto instance) =>
    <String, dynamic>{
      'type': _$AttachmentTypeEnumMap[instance.type],
      'url': instance.url,
    };

const _$AttachmentTypeEnumMap = {
  AttachmentType.picture: 'picture',
  AttachmentType.pdf: 'pdf',
  AttachmentType.url: 'url',
};
