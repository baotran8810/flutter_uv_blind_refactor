import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/base_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/hive_constants.dart';
import 'package:hive/hive.dart';

part 'app_setting_entity.g.dart';

const String uniqueId = 'UNIQUE';

@HiveType(typeId: HiveConst.appSettingTid)
class AppSettingEntity extends BaseEntity {
  @HiveField(1)
  final bool continuousScan;

  @HiveField(2)
  final bool flashlight;

  @HiveField(3)
  final Gender readingGender;

  @HiveField(4)
  final bool soundApp;

  @HiveField(5)
  final int radiusGPS;

  @HiveField(6)
  final int distanceOutOfRange;

  @HiveField(7)
  final bool voiceGuide;

  @HiveField(8)
  final bool voiceGuidanceWithShake;

  @HiveField(9)
  final bool vibration;

  @HiveField(10)
  final double voiceGuideSpeed;

  @HiveField(11)
  final int colorIndex;

  @HiveField(12)
  final int borderLevel;

  @HiveField(13)
  final double audioReadingSpeed;

  @HiveField(14)
  final bool signLanguage;

  @HiveField(15, defaultValue: AppVoice.device)
  final AppVoice appVoice;

  @HiveField(16, defaultValue: false)
  final bool isAutoplayReading;

  @HiveField(17, defaultValue: 1.0)
  final double voicePitch;

  @HiveField(18, defaultValue: AppVoice.univoice)
  final AppVoice appVoiceReadingPage;

  AppSettingEntity({
    required this.colorIndex,
    required this.borderLevel,
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
  }) : super(id: uniqueId);
}
