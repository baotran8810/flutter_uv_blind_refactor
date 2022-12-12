import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/extensions/list_extension.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_dto.g.dart';

@JsonSerializable()
class NotificationDto {
  final int id;

  @JsonKey(name: 'company_id')
  final int companyId;

  @JsonKey(name: 'localized_messages')
  final List<NotifLocalizedMessageDto>? localizedMessageList;

  @JsonKey(name: 'webview_url')
  final String webviewUrl;

  @JsonKey(name: 'qrcode')
  final NotifQrCodeDto? qrCode;

  @JsonKey(name: 'last_push')
  final DateTime lastPushAt;

  /// Can't rely on this to display likedCount,
  /// use getLikeCount endpoint instead
  @JsonKey(name: 'liked_count')
  final int? likedCount;

  final NotifCompanyDto? company;

  @JsonKey(name: 'attachment')
  final List<NotifAttachmentDto>? attachmentList;

  NotificationDto({
    required this.id,
    required this.companyId,
    required this.localizedMessageList,
    required this.webviewUrl,
    required this.qrCode,
    required this.lastPushAt,
    required this.likedCount,
    required this.company,
    required this.attachmentList,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationDtoToJson(this);

  NotifLocalizedMessageDto _getLocalizedMessageItem() {
    if (localizedMessageList == null) {
      return NotifLocalizedMessageDto(
        lang: 'N/A',
        title: 'N/A',
        content: 'N/A',
      );
    }

    if (localizedMessageList!.isEmpty) {
      throw Exception('Custom: localizedMessageList cannot be empty');
    }

    final String languageCode =
        LocalizationUtils.getCurrentLocale().languageCode;

    final foundMessageItem = localizedMessageList!
        .firstWhereOrNull((message) => message.lang == languageCode);

    return foundMessageItem ?? localizedMessageList![0];
  }

  String getTitle() {
    return _getLocalizedMessageItem().title;
  }

  String getContent() {
    return _getLocalizedMessageItem().content;
  }

  String getLang() {
    return _getLocalizedMessageItem().lang;
  }
}

@JsonSerializable()
class NotifLocalizedMessageDto {
  final String lang;
  final String title;
  final String content;

  const NotifLocalizedMessageDto({
    required this.lang,
    required this.title,
    required this.content,
  });

  factory NotifLocalizedMessageDto.fromJson(Map<String, dynamic> json) =>
      _$NotifLocalizedMessageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NotifLocalizedMessageDtoToJson(this);
}

@JsonSerializable()
class NotifQrCodeDto {
  final String link;

  const NotifQrCodeDto({
    required this.link,
  });

  factory NotifQrCodeDto.fromJson(Map<String, dynamic> json) =>
      _$NotifQrCodeDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NotifQrCodeDtoToJson(this);
}

@JsonSerializable()
class NotifCompanyDto {
  final int id;

  @JsonKey(name: 'company_name')
  final String companyName;

  const NotifCompanyDto({
    required this.id,
    required this.companyName,
  });

  factory NotifCompanyDto.fromJson(Map<String, dynamic> json) =>
      _$NotifCompanyDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NotifCompanyDtoToJson(this);
}

@JsonSerializable()
class NotifAttachmentDto {
  final AttachmentType type;
  final String url;

  const NotifAttachmentDto({
    required this.type,
    required this.url,
  });

  factory NotifAttachmentDto.fromJson(Map<String, dynamic> json) =>
      _$NotifAttachmentDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NotifAttachmentDtoToJson(this);
}
