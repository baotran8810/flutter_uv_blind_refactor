// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PointEntityAdapter extends TypeAdapter<PointEntity> {
  @override
  final int typeId = 6;

  @override
  PointEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PointEntity(
      pointName: fields[1] as String,
      pointInfo: fields[2] as String?,
      beaconId: fields[3] as String?,
      coordinate: fields[4] as CoordinateEntity,
      categoryList: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PointEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.pointName)
      ..writeByte(2)
      ..write(obj.pointInfo)
      ..writeByte(3)
      ..write(obj.beaconId)
      ..writeByte(4)
      ..write(obj.coordinate)
      ..writeByte(5)
      ..write(obj.categoryList)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
