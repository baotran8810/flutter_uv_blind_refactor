// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_setting_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LanguageSettingEntityAdapter extends TypeAdapter<LanguageSettingEntity> {
  @override
  final int typeId = 1;

  @override
  LanguageSettingEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LanguageSettingEntity(
      currentLangKey: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LanguageSettingEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.currentLangKey)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageSettingEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
