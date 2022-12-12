import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/hive_constants.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'enums.g.dart';

enum SupportedLanguage { en, ja }

extension SupportedLanguageExt on SupportedLanguage {
  Locale getLocale() {
    switch (this) {
      case SupportedLanguage.en:
        return Locale('en');
      case SupportedLanguage.ja:
        return Locale('ja');
    }
  }
}

@HiveType(typeId: HiveConst.scanCodeTid)
enum ScanCodeType {
  @HiveField(0)
  navi,
  @HiveField(1)
  facility,
  @HiveField(2)
  doc
}

extension ScanCodeTypeExt on ScanCodeType {
  String getTagKey() {
    switch (this) {
      case ScanCodeType.navi:
        return '#nc';
      case ScanCodeType.facility:
        return '#nf';
      case ScanCodeType.doc:
        return 'doc';
    }
  }

  String getDisplayName() {
    switch (this) {
      case ScanCodeType.navi:
        return tra(LocaleKeys.txt_navi);
      case ScanCodeType.facility:
        return tra(LocaleKeys.txt_facility);
      case ScanCodeType.doc:
        return tra(LocaleKeys.txt_doc);
    }
  }
}

@HiveType(typeId: HiveConst.genderTid)
enum Gender {
  @HiveField(0)
  @JsonValue('male')
  male,
  @HiveField(1)
  @JsonValue('female')
  female,
}

@HiveType(typeId: HiveConst.appVoiceTid)
enum AppVoice {
  @HiveField(0)
  @JsonValue('device')
  device,
  @HiveField(1)
  @JsonValue('univoice')
  univoice,
}

enum AppLocationStatus {
  notAsked,
  denied,
  loading,
  loaded,
}

enum AttachmentType {
  @JsonValue('picture')
  picture,
  @JsonValue('pdf')
  pdf,
  @JsonValue('url')
  url,
}

extension AttachmentTypeExt on AttachmentType {
  IconData getIconData() {
    switch (this) {
      case AttachmentType.picture:
        return CommunityMaterialIcons.picture_in_picture_bottom_right;
      case AttachmentType.pdf:
        return CommunityMaterialIcons.pdf_box;
      case AttachmentType.url:
        return CommunityMaterialIcons.link;
    }
  }
}

enum PointCategoryType {
  institution,
  accommodation,
  transportation,
  shrine,
  restaurant,
  shopping,
  medical,
  sightseeing,
  evacShelter,
  shelter,
  publicPhone,
  specialPhone,
  stadium,
  government,
  school,
  convenienceStore,
  gasStation,
  postBox,
  museum,
  scenicSites,
  naturalScenery,
  workshop,
  church,
  waterStation,
  publicRestroom,
  tempStayFacility,
  shortTermEva,
  socialWelfareInstitutionEva,
  aed,
  tsunamiEva,
  policeStation,
  fireStation,
  hospital,
  disasterEmergencyHospital,
  emergencyHelicopter,
  fireHydrant,
}
