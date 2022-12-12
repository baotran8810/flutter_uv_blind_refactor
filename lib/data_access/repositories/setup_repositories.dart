import 'package:flutter_uv_blind_refactor/common/utility/utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/address_repository/address_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/address_repository/address_repository_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/app_data_repository/app_data_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/app_data_repository/app_data_repository_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/app_setting_repository/app_setting_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/app_setting_repository/app_setting_repository_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/language_setting_repository/language_setting_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/language_setting_repository/language_setting_repository_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/notification_repository/notification_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/notification_repository/notification_repository_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/scan_code_repository/scan_code_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/scan_code_repository/scan_code_repository_impl.dart';
import 'package:get/get.dart';

void setupRepositories() {
  putPermanent<NotificationRepository>(
    NotificationRepositoryImpl(
      restClient: Get.find(),
      notificationsInfoDao: Get.find(),
      addressSettingDao: Get.find(),
    ),
  );
  putPermanent<AddressRepository>(
    AddressRepositoryImpl(
      restClient: Get.find(),
      addressSettingDao: Get.find(),
    ),
  );
  putPermanent<LanguageSettingRepository>(
    LanguageSettingRepositoryImpl(
      languageSettingDao: Get.find(),
    ),
  );
  putPermanent<ScanCodeRepository>(
    ScanCodeRepositoryImpl(
      scanCodeDao: Get.find(),
      scanCodeSqlDao: Get.find(),
      restClient: Get.find(),
    ),
  );
  putPermanent<AppSettingRepository>(
    AppSettingRepositoryImpl(
      appSettingDao: Get.find(),
    ),
  );
  putPermanent<AppDataRepository>(
    AppDataRepositoryImpl(
      appDataDao: Get.find(),
    ),
  );
}
