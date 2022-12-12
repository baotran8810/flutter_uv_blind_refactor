import 'package:flutter_uv_blind_refactor/common/utility/utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/app_hive.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/address_setting_dao/address_setting_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/address_setting_dao/address_setting_dao_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/app_data_dao/app_data_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/app_data_dao/app_data_dao_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/app_setting_dao/app_setting_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/app_setting_dao/app_setting_dao_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/language_setting_dao/language_setting_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/language_setting_dao/language_setting_dao_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/notifications_info_dao/notifications_info_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/notifications_info_dao/notifications_info_dao_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/scan_code_dao/scan_code_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/scan_code_dao/scan_code_dao_impl.dart';

Future<void> setupHive() async {
  final hiveDatabase = putPermanent<AppHive>(AppHive());
  await hiveDatabase.init();

  _setupHiveDaos();
}

void _setupHiveDaos() {
  putPermanent<NotificationsInfoDao>(NotificationsInfoDaoImpl());
  putPermanent<LanguageSettingDao>(LanguageSettingDaoImpl());
  putPermanent<AddressSettingDao>(AddressSettingDaoImpl());
  putPermanent<ScanCodeDao>(ScanCodeDaoImpl());
  putPermanent<AppSettingDao>(AppSettingDaoImpl());
  putPermanent<AppDataDao>(AppDataDaoImpl());
}
