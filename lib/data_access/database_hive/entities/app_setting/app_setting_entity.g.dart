// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_setting_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingEntityAdapter extends TypeAdapter<AppSettingEntity> {
  @override
  final int typeId = 9;

  @override
  AppSettingEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettingEntity(
      colorIndex: fields[11] as int,
      borderLevel: fields[12] as int,
      continuousScan: fields[1] as bool,
      flashlight: fields[2] as bool,
      readingGender: fields[3] as Gender,
      soundApp: fields[4] as bool,
      radiusGPS: fields[5] as int,
      distanceOutOfRange: fields[6] as int,
      voiceGuide: fields[7] as bool,
      voiceGuidanceWithShake: fields[8] as bool,
      vibration: fields[9] as bool,
      voiceGuideSpeed: fields[10] as double,
      audioReadingSpeed: fields[13] as double,
      signLanguage: fields[14] as bool,
      appVoice: fields[15] == null ? AppVoice.device : fields[15] as AppVoice,
      isAutoplayReading: fields[16] == null ? false : fields[16] as bool,
      voicePitch: fields[17] == null ? 1.0 : fields[17] as double,
      appVoiceReadingPage:
          fields[18] == null ? AppVoice.univoice : fields[18] as AppVoice,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettingEntity obj) {
    writer
      ..writeByte(19)
      ..writeByte(1)
      ..write(obj.continuousScan)
      ..writeByte(2)
      ..write(obj.flashlight)
      ..writeByte(3)
      ..write(obj.readingGender)
      ..writeByte(4)
      ..write(obj.soundApp)
      ..writeByte(5)
      ..write(obj.radiusGPS)
      ..writeByte(6)
      ..write(obj.distanceOutOfRange)
      ..writeByte(7)
      ..write(obj.voiceGuide)
      ..writeByte(8)
      ..write(obj.voiceGuidanceWithShake)
      ..writeByte(9)
      ..write(obj.vibration)
      ..writeByte(10)
      ..write(obj.voiceGuideSpeed)
      ..writeByte(11)
      ..write(obj.colorIndex)
      ..writeByte(12)
      ..write(obj.borderLevel)
      ..writeByte(13)
      ..write(obj.audioReadingSpeed)
      ..writeByte(14)
      ..write(obj.signLanguage)
      ..writeByte(15)
      ..write(obj.appVoice)
      ..writeByte(16)
      ..write(obj.isAutoplayReading)
      ..writeByte(17)
      ..write(obj.voicePitch)
      ..writeByte(18)
      ..write(obj.appVoiceReadingPage)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
