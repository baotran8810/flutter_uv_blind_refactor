// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_data_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppDataEntityAdapter extends TypeAdapter<AppDataEntity> {
  @override
  final int typeId = 11;

  @override
  AppDataEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppDataEntity(
      isOnboardCompleted: fields[1] as bool,
      pollyLastModifiedAt: fields[2] as DateTime,
      signLanguageId: fields[3] as String,
      hasMigratedFromOldApp: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, AppDataEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.isOnboardCompleted)
      ..writeByte(2)
      ..write(obj.pollyLastModifiedAt)
      ..writeByte(3)
      ..write(obj.signLanguageId)
      ..writeByte(4)
      ..write(obj.hasMigratedFromOldApp)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppDataEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
