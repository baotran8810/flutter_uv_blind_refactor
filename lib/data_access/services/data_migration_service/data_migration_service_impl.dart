import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/utility/extensions/double_extension.dart';
import 'package:flutter_uv_blind_refactor/common/utility/extensions/list_extension.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/log_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/address/address_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/app_setting/app_setting_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/address_repository/address_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/app_data_repository/app_data_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/app_setting_repository/app_setting_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/language_setting_repository/language_setting_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/scan_code_repository/scan_code_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/data_migration_service/data_migration_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/scan_decode_service/scan_decode_service.dart';

class DataMigrationServiceImpl implements DataMigrationService {
  final AppDataRepository _appDataRepository;
  final ScanDecodeService _scanDecodeService;
  final AddressRepository _addressRepository;
  final ScanCodeRepository _scanCodeRepository;
  final AppSettingRepository _appSettingRepository;
  final LanguageSettingRepository _languageRepository;
  static const dmService = MethodChannel('uv_migration');

  DataMigrationServiceImpl({
    required AppDataRepository appDataRepository,
    required ScanDecodeService scanDecodeService,
    required AddressRepository addressRepository,
    required ScanCodeRepository scanCodeRepository,
    required AppSettingRepository appSettingRepository,
    required LanguageSettingRepository languageRepository,
  })  : _appDataRepository = appDataRepository,
        _addressRepository = addressRepository,
        _scanDecodeService = scanDecodeService,
        _scanCodeRepository = scanCodeRepository,
        _appSettingRepository = appSettingRepository,
        _languageRepository = languageRepository {
    dmService.setMethodCallHandler(handler);
  }

  Future<dynamic> handler(MethodCall call) async {
    switch (call.method) {
      case 'start_migrate':
        LogUtils.iNoST('Start migrating data from the old app...');
        break;
      case 'migrate_address':
        final Map<dynamic, dynamic> address =
            call.arguments as Map<dynamic, dynamic>;
        _migrateTagData(address);
        break;
      case 'migrate_scan_code':
        final Map<dynamic, dynamic> fileData =
            call.arguments as Map<dynamic, dynamic>;
        _migrateScanCode(fileData);
        break;
      case 'migrate_settings':
        final Map<dynamic, dynamic> settingsData =
            call.arguments as Map<dynamic, dynamic>;
        _migrateSettings(settingsData);
        break;
      case 'end_migrate':
        _appDataRepository.saveData(
          hasMigratedFromOldApp: true,
        );
        break;
    }
  }

  Future<void> _migrateTagData(Map<dynamic, dynamic> address) async {
    print(address);
    try {
      final addressJson = Map<String, dynamic>.from(address);
      addressJson['tagData'] = Map<String, dynamic>.from(
        addressJson['tagData'] as Map<dynamic, dynamic>,
      );

      final addressDto = AddressDto.fromJson(addressJson);
      await _addressRepository.setAddress(addressDto);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _migrateScanCode(Map<dynamic, dynamic> fileData) async {
    final String? codeStr = fileData['sourceContent'] as String?;
    final String? createdDateStr = fileData['createdDate'] as String?;
    // Only for legacy doc code
    final String? langKey = fileData['targetLanguage'] as String?;

    if (codeStr == null) {
      return;
    }

    final createdDate =
        DateTime.tryParse(createdDateStr ?? 'N/A') ?? DateTime.now();

    final decodeResult = await _scanDecodeService.decodeFromString(
      codeStr,
      legacyDocCodeLangKey: langKey,
      createdDate: createdDate,
      logEventHandler: null,
    );

    if (decodeResult != null) {
      await _scanCodeRepository.addOrUpdateScanCodeList(
        decodeResult.scanCodeList,
      );
    }
  }

  Future<void> _migrateSettings(Map<dynamic, dynamic> data) async {
    if (_doNeedMigrateSetting(data) == false) {
      return;
    }

    final bool? continuousScan = data['setting_continuous_scan'] as bool?;
    final int? distanceOutOfRange = data['uvb.setting_out_of_course'] as int?;
    final bool? flashLight = data['setting_camera_light'] as bool?;
    final int? radiusGPS = data['uvb.setting_checkin_radius'] as int?;
    final bool? soundApp = data['setting_no_scan_sound'] as bool?;
    final bool? vibrate = data['uvb.setting_vibe'] as bool?;
    final bool? voiceGuidanceWithShake = data['uvb.setting_shake'] as bool?;
    final bool? voiceGuide = data['uvb.setting_guive_voice'] as bool?;
    final int? borderLevelIndex = data['setting_thickness_level'] as int?;
    final bool? signLanguage = data['setting_sign_language'] as bool?;

    final double? audioReadingSpeed = _remapSpeedValue(
      input: data['setting_speed_read_out'] as double?,
      minValue: 0.192,
      maxValue: 0.448,
    );
    final double? voiceGuideSpeed = _remapSpeedValue(
      input: data['uvb.setting_voice_speed'] as double?,
      minValue: 0.3,
      maxValue: 0.7,
    );

    final int? colorIndex =
        _remapBorderColorSetting(data['setting_color_border'] as List?);

    final String? langKey =
        remapLanguageSetting(data['setting_language'] as int?);

    await Future.wait([
      _appSettingRepository.saveSetting(
        continuousScan: continuousScan,
        flashlight: flashLight,
        soundApp: soundApp,
        audioReadingSpeed: audioReadingSpeed,
        radiusGPS: radiusGPS,
        distanceOutOfRange: distanceOutOfRange,
        voiceGuide: voiceGuide,
        voiceGuidanceWithShake: voiceGuidanceWithShake,
        vibration: vibrate,
        voiceGuideSpeed: voiceGuideSpeed,
        borderLevelIndex: borderLevelIndex,
        colorIndex: colorIndex,
        signLanguage: signLanguage,
      ),
      if (langKey != null) _languageRepository.setLangKey(langKey),
    ]);
  }

  /// ! Workaround to check if need to migrate
  bool _doNeedMigrateSetting(Map<dynamic, dynamic> data) {
    final voiceGuideSpeed = data['uvb.setting_voice_speed'] as double?;
    if (voiceGuideSpeed != null && voiceGuideSpeed == 0) {
      return false;
    }

    return true;
  }

  int? _remapBorderColorSetting(List? input) {
    if (input == null) {
      return null;
    }

    final color = AppColors.oldScanBorderColorList.firstWhereOrNull(
      (oldColor) => oldColor.toString() == input.toString(),
    );

    if (color == null) {
      return null;
    }

    final colorIndex = AppColors.oldScanBorderColorList.indexOf(color);
    return colorIndex;
  }

  double? _remapSpeedValue({
    required double? input,
    required double minValue,
    required double maxValue,
  }) {
    if (input == null) {
      return null;
    }

    if (input < minValue || input > maxValue) {
      return null;
    }

    return input.map(
      inputMin: minValue,
      inputMax: maxValue,
      outputMin: SpeakingSpeedRange.kMin,
      outputMax: SpeakingSpeedRange.kMax,
    );
  }

  /// return langKey
  String? remapLanguageSetting(int? input) {
    // ENGLISH_US  = 0,
    // JAPANESE    = 1,
    // SIMPLIFIED_CHINESE = 2,
    // TRADITIONAL_CHINESE= 3,
    // KOREAN      = 4,
    // FRENCH      = 5,
    // GERMAN      = 6,
    // SPANISH     = 7,
    // ITALIAN     = 8,
    // PORTUGUESE  = 9,
    // RUSSIAN     = 10,
    // THAI        = 11,
    // INDONESIAN  = 12,
    // ARABIC      = 13
    if (input == null) {
      return null;
    }

    switch (input) {
      case 0:
        return '.eng';
      case 1:
        return '.jpn';
      case 2:
        return '.chi';
      case 3:
        return '.zho';
      case 4:
        return '.kor';
      case 5:
        return '.fre';
      case 6:
        return '.ger';
      case 7:
        return '.spa';
      case 8:
        return '.ita';
      case 9:
        return '.por';
      case 10:
        return '.rus';
      case 11:
        return '.tai';
      case 12:
        return '.ind';
      case 13:
        return '.ara';
      default:
        return null;
    }
  }

  @override
  void startMigrate() {
    if (!Platform.isIOS) return;
    dmService.invokeMethod('check_migrated');
  }
}
