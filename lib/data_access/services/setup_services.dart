import 'package:flutter_uv_blind_refactor/common/utility/utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/analytics_service/analytics_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/analytics_service/analytics_service_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/data_migration_service/data_migration_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/data_migration_service/data_migration_service_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/deeplink_service/deeplink_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/deeplink_service/deeplink_service_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/hardware_service/hardware_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/hardware_service/hardware_service_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/location_service/location_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/location_service/location_service_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/push_notif_service/push_notif_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/push_notif_service/push_notif_service_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/remove_config_service/remote_config_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/remove_config_service/remote_config_service_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/scan_decode_service/scan_decode_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/scan_decode_service/scan_decode_service_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/sign_language_url/sign_language_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/sign_language_url/sign_language_service_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/voice_input_service/voice_input_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/voice_input_service/voice_input_service_impl.dart';
import 'package:get/get.dart';

// ! Order matters. Beware of circular dep

void setupServices() {
  putPermanent<AnalyticsService>(
    AnalyticsServiceImpl(),
  );
  putPermanent<HardwareService>(
    HardwareServiceImpl(
      appSettingRepository: Get.find(),
    ),
  );
  
  putPermanent<ScanDecodeService>(
    ScanDecodeServiceImpl(
      restClient: Get.find(),
      languageSettingRepository: Get.find(),
    ),
  );
  putPermanent<SpeakingService>(
    SpeakingServiceImpl(
      restClient: Get.find(),
      appSettingRepository: Get.find(),
      // ! Beware of circular dep
      analyticsService: Get.find(),
      hardwareService: Get.find(),
    ),
  );
  putPermanent<PushNotifService>(
    PushNotifServiceImpl(),
  );
  putPermanent<LocationService>(
    LocationServiceImpl(),
  );
  putPermanent<DeeplinkService>(
    DeeplinkServiceImpl(),
  );
  putPermanent<VoiceInputService>(
    VoiceInputServiceImpl(),
  );
  putPermanent<RemoteConfigService>(
    RemoteConfigServiceImpl(),
  );
  putPermanent<DataMigrationService>(
    DataMigrationServiceImpl(
      appDataRepository: Get.find(),
      addressRepository: Get.find(),
      scanCodeRepository: Get.find(),
      appSettingRepository: Get.find(),
      languageRepository: Get.find(),
      // ! Beware of circular dep
      scanDecodeService: Get.find(),
    ),
  );
  putPermanent<SignLanguageService>(
    SignLanguageServiceImpl(
      appDataDao: Get.find(),
      languageSettingDao: Get.find(),
    ),
  );
}
