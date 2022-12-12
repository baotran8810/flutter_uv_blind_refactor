import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/app_setting/app_setting_dto.dart';

abstract class AppSettingRepository {
  Future<AppSettingDto> getAppSetting();

  Future<AppSettingDto> saveSetting({
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
    int? borderLevelIndex,
    int? colorIndex,
    double? audioReadingSpeed,
    bool? signLanguage,
    AppVoice? appVoice,
    bool? isAutoplayReading,
    double? voicePitch,
    AppVoice? appVoiceReadingPage,
  });
}

const List<int> kRadiusGpsSettingList = [5, 10, 15, 20, 30, 50];
const List<int> kDistanceOutOfRangeSettingList = [
  30,
  50,
  100,
  150,
  200,
  1000,
];
