import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/app_setting/app_setting_dto.dart';

abstract class SettingController {
  /// Only `null` for a short amount of time when init
  AppSettingDto? get appSetting;
  String? get currentAddress;

  Future<void> setContinuousScan(bool value);
  Future<void> setFlashLight(bool value);
  Future<void> setSoundApp(bool value);
  Future<void> setReadingGender(Gender value);
  Future<void> setRadiusGPS(int value);
  Future<void> setDistanceOutOfRange(int value);
  Future<void> setVoiceGuide(bool value);
  Future<void> setVibrate(bool value);
  Future<void> setVoiceGuidanceWithShake(bool value);
  Future<void> setAudioPlayBackSpeed(double value);
  Future<void> setAudioReadingSpeed(double value);
  Future<void> setVoicePitch(double value);
  Future<void> setSignLanguage(bool value);
  Future<void> setAppVoice(AppVoice value);
  Future<void> setIsAutoplayReading(bool value);
  void reloadAddress();
}
