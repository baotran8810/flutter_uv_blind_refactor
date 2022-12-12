import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/address_setting/address_setting_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/app_data/app_data_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/app_setting/app_setting_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/language_setting/language_setting_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/notifications_info/notifications_info_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/doc_scan_code_entity/doc_scan_code_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/facility_scan_code_entity/facility_scan_code_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/miscs/code_info_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/navi_scan_code_entity/navi_scan_code_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/point_entity/coordinate_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/point_entity/point_entity.dart';
import 'package:hive/hive.dart';

class HiveConst {
  static const String notificationsInfoName = 'notifications-info';
  static const int notificationsInfoTid = 0;

  static const String languageSettingName = 'language-setting';
  static const int languageSettingTid = 1;

  static const String addressSettingName = 'address-setting';
  static const int addressSettingTid = 2;

  static const String docScanCodeName = "doc-scan-code";
  static const int docScanCodeTid = 3;

  static const String naviScanCodeName = "navi-scan-code";
  static const int naviScanCodeTid = 4;

  static const String facilityScanCodeName = "facility-scan-code";
  static const int facilityScanCodeTid = 5;

  static const int pointEntityTid = 6;

  static const int coordinateInfoTid = 7;

  static const int scanCodeTid = 8;

  static const String appSettingName = "app-setting";
  static const int appSettingTid = 9;

  static const int genderTid = 10;

  static const String appDataName = "app-data";
  static const int appDataTid = 11;

  static const int codeInfoTid = 12;

  static const int appVoiceTid = 13;
}

class HiveBoxMap {
  static Map<Type, HiveInfo> hiveBoxMap = {
    NotificationsInfoEntity: HiveInfo<NotificationsInfoEntity>(
      boxName: HiveConst.notificationsInfoName,
      registerAdapterFunction: () {
        Hive.registerAdapter(NotificationsInfoEntityAdapter());
      },
    ),
    LanguageSettingEntity: HiveInfo<LanguageSettingEntity>(
      boxName: HiveConst.languageSettingName,
      registerAdapterFunction: () {
        Hive.registerAdapter(LanguageSettingEntityAdapter());
      },
    ),
    AddressSettingEntity: HiveInfo<AddressSettingEntity>(
      boxName: HiveConst.addressSettingName,
      registerAdapterFunction: () {
        Hive.registerAdapter(AddressSettingEntityAdapter());
      },
    ),
    DocScanCodeEntity: HiveInfo<DocScanCodeEntity>(
      boxName: HiveConst.docScanCodeName,
      registerAdapterFunction: () {
        Hive.registerAdapter(DocScanCodeEntityAdapter());
      },
    ),
    NaviScanCodeEntity: HiveInfo<NaviScanCodeEntity>(
      boxName: HiveConst.naviScanCodeName,
      registerAdapterFunction: () {
        Hive.registerAdapter(NaviScanCodeEntityAdapter());
      },
    ),
    FacilityScanCodeEntity: HiveInfo<FacilityScanCodeEntity>(
      boxName: HiveConst.facilityScanCodeName,
      registerAdapterFunction: () {
        Hive.registerAdapter(FacilityScanCodeEntityAdapter());
      },
    ),
    AppSettingEntity: HiveInfo<AppSettingEntity>(
      boxName: HiveConst.appSettingName,
      registerAdapterFunction: () {
        Hive.registerAdapter(AppSettingEntityAdapter());
      },
    ),
    AppDataEntity: HiveInfo<AppDataEntity>(
      boxName: HiveConst.appDataName,
      registerAdapterFunction: () {
        Hive.registerAdapter(AppDataEntityAdapter());
      },
    ),
  };

  /// For Nested entity, Enum, etc
  static void registerMiscAdapters() {
    Hive.registerAdapter(ScanCodeTypeAdapter());
    Hive.registerAdapter(PointEntityAdapter());
    Hive.registerAdapter(CoordinateEntityAdapter());
    Hive.registerAdapter(CodeInfoEntityAdapter());
    Hive.registerAdapter(GenderAdapter());
    Hive.registerAdapter(AppVoiceAdapter());
  }
}

class HiveInfo<EntityT> {
  String boxName;
  late Future<void> Function() openBoxFunction;
  void Function() registerAdapterFunction;

  HiveInfo({
    required this.boxName,
    required this.registerAdapterFunction,
  }) {
    openBoxFunction = () async {
      await Hive.openBox<EntityT>(boxName);
    };
  }
}
