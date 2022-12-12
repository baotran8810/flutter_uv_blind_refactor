// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinate_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoordinateEntityAdapter extends TypeAdapter<CoordinateEntity> {
  @override
  final int typeId = 7;

  @override
  CoordinateEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CoordinateEntity(
      latitude: fields[1] as double,
      longitude: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CoordinateEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoordinateEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
