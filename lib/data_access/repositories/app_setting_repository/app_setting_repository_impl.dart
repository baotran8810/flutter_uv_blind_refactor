import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/app_setting_dao/app_setting_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/app_setting/app_setting_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/app_setting_repository/app_setting_repository.dart';

class AppSettingRepositoryImpl implements AppSettingRepository {
  final AppSettingDao _appSettingDao;

  AppSettingRepositoryImpl({
    required AppSettingDao appSettingDao,
  }) : _appSettingDao = appSettingDao;

  @override
  Future<AppSettingDto> getAppSetting() async {
    return await _appSettingDao.getAppSetting();
  }

  @override
  Future<AppSettingDto> saveSetting({
    int? colorIndex,
    int? borderLevelIndex,
    bool? continuousScan,
    bool? flashlight,
    Gender? readingGender,
    bool? soundApp,
    int? radiusGPS,
    int? distanceOutOfRange,
    bool? voiceGuide,
    bool? voiceGuidanceWithShake,
    bool? vibration,
    double? voiceGuideSpeed,
    double? audioReadingSpeed,
    bool? signLanguage,
    AppVoice? appVoice,
    bool? isAutoplayReading,
    double? voicePitch,
    AppVoice? appVoiceReadingPage,
  }) async {
    final currentAppSetting = await _appSettingDao.getAppSetting();

    // Make sure setting values are valid

    final newRadiusGPS =
        kRadiusGpsSettingList.contains(radiusGPS) ? radiusGPS : null;

    final newDistanceOutOfRange =
        kDistanceOutOfRangeSettingList.contains(distanceOutOfRange)
            ? distanceOutOfRange
            : null;

    // Start saving

    final newAppSetting = AppSettingDto(
      colorIndex: colorIndex ?? currentAppSetting.colorIndex,
      borderLevelIndex: borderLevelIndex ?? currentAppSetting.borderLevelIndex,
      continuousScan: continuousScan ?? currentAppSetting.continuousScan,
      flashlight: flashlight ?? currentAppSetting.flashlight,
      readingGender: readingGender ?? currentAppSetting.readingGender,
      soundApp: soundApp ?? currentAppSetting.soundApp,
      radiusGPS: newRadiusGPS ?? currentAppSetting.radiusGPS,
      distanceOutOfRange:
          newDistanceOutOfRange ?? currentAppSetting.distanceOutOfRange,
      voiceGuide: voiceGuide ?? currentAppSetting.voiceGuide,
      voiceGuidanceWithShake:
          voiceGuidanceWithShake ?? currentAppSetting.voiceGuidanceWithShake,
      vibration: vibration ?? currentAppSetting.vibration,
      voiceGuideSpeed: voiceGuideSpeed ?? currentAppSetting.voiceGuideSpeed,
      audioReadingSpeed:
          audioReadingSpeed ?? currentAppSetting.audioReadingSpeed,
      signLanguage: signLanguage ?? currentAppSetting.signLanguage,
      appVoice: appVoice ?? currentAppSetting.appVoice,
      isAutoplayReading:
          isAutoplayReading ?? currentAppSetting.isAutoplayReading,
      voicePitch: voicePitch ?? currentAppSetting.voicePitch,
      appVoiceReadingPage:
          appVoiceReadingPage ?? currentAppSetting.appVoiceReadingPage,
    );

    return await _appSettingDao.saveAppSetting(newAppSetting);
  }
}
