import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/app_setting/app_setting_entity.dart';

class AppSettingDto {
  // == For scan setting
  final int colorIndex;
  final int borderLevelIndex;

  final bool continuousScan;
  final bool flashlight;
  final Gender readingGender;
  final bool soundApp;
  final bool signLanguage;

  // == For voice guide (navi compass)
  final int radiusGPS;
  final int distanceOutOfRange;
  final bool voiceGuide;
  final bool voiceGuidanceWithShake;
  final bool vibration;

  /// value range: [SpeakingSpeedRange]
  final double voiceGuideSpeed;

  // == For reading setting
  /// value range: [SpeakingSpeedRange]
  final double audioReadingSpeed;

  final AppVoice appVoice;
  final bool isAutoplayReading;

  /// value range: [SpeakingPitchRange]
  final double voicePitch;

  final AppVoice appVoiceReadingPage;

  AppSettingDto({
    required this.colorIndex,
    required this.borderLevelIndex,
    required this.continuousScan,
    required this.flashlight,
    required this.readingGender,
    required this.soundApp,
    required this.radiusGPS,
    required this.distanceOutOfRange,
    required this.voiceGuide,
    required this.voiceGuidanceWithShake,
    required this.vibration,
    required this.voiceGuideSpeed,
    required this.audioReadingSpeed,
    required this.signLanguage,
    required this.appVoice,
    required this.isAutoplayReading,
    required this.voicePitch,
    required this.appVoiceReadingPage,
  });

  /// Default value when opening the app for the first time
  factory AppSettingDto.initDefault() {
    return AppSettingDto(
      colorIndex: 0,
      borderLevelIndex: 0,
      continuousScan: false,
      flashlight: false,
      readingGender: Gender.female,
      soundApp: false,
      radiusGPS: 5,
      distanceOutOfRange: 30,
      voiceGuide: true,
      voiceGuidanceWithShake: true,
      vibration: true,
      voiceGuideSpeed: 1,
      audioReadingSpeed: 1,
      signLanguage: false,
      appVoice: AppVoice.device,
      isAutoplayReading: false,
      voicePitch: 1,
      appVoiceReadingPage: AppVoice.univoice,
    );
  }

  factory AppSettingDto.fromEntity(AppSettingEntity entity) {
    return AppSettingDto(
      colorIndex: entity.colorIndex,
      borderLevelIndex: entity.borderLevel,
      continuousScan: entity.continuousScan,
      flashlight: entity.flashlight,
      readingGender: entity.readingGender,
      soundApp: entity.soundApp,
      radiusGPS: entity.radiusGPS,
      distanceOutOfRange: entity.distanceOutOfRange,
      voiceGuide: entity.voiceGuide,
      voiceGuidanceWithShake: entity.voiceGuidanceWithShake,
      vibration: entity.vibration,
      voiceGuideSpeed: entity.voiceGuideSpeed,
      audioReadingSpeed: entity.audioReadingSpeed,
      signLanguage: entity.signLanguage,
      appVoice: entity.appVoice,
      isAutoplayReading: entity.isAutoplayReading,
      voicePitch: entity.voicePitch,
      appVoiceReadingPage: entity.appVoiceReadingPage,
    );
  }

  AppSettingEntity toEntity() {
    return AppSettingEntity(
      colorIndex: colorIndex,
      borderLevel: borderLevelIndex,
      continuousScan: continuousScan,
      flashlight: flashlight,
      readingGender: readingGender,
      soundApp: soundApp,
      radiusGPS: radiusGPS,
      distanceOutOfRange: distanceOutOfRange,
      voiceGuide: voiceGuide,
      voiceGuidanceWithShake: voiceGuidanceWithShake,
      vibration: vibration,
      voiceGuideSpeed: voiceGuideSpeed,
      audioReadingSpeed: audioReadingSpeed,
      signLanguage: signLanguage,
      appVoice: appVoice,
      isAutoplayReading: isAutoplayReading,
      voicePitch: voicePitch,
      appVoiceReadingPage: appVoiceReadingPage,
    );
  }
}

abstract class SpeakingSpeedRange {
  static const kMin = 0.5;
  static const kMax = 2.0;
}

abstract class SpeakingPitchRange {
  static const kMin = 0.5;
  static const kMax = 2.0;
}
