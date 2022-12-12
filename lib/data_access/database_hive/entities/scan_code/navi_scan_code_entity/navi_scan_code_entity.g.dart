// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navi_scan_code_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NaviScanCodeEntityAdapter extends TypeAdapter<NaviScanCodeEntity> {
  @override
  final int typeId = 4;

  @override
  NaviScanCodeEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NaviScanCodeEntity(
      id: fields[0] as String,
      name: fields[1] as String,
      codeType: fields[3] as ScanCodeType,
      date: fields[2] as DateTime,
      isBookmark: fields[4] as bool,
      codeInfo: fields[5] as CodeInfoEntity?,
      codeStr: fields[6] as String?,
      pointList: (fields[101] as List).cast<PointEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, NaviScanCodeEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(101)
      ..write(obj.pointList)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.codeType)
      ..writeByte(4)
      ..write(obj.isBookmark)
      ..writeByte(5)
      ..write(obj.codeInfo)
      ..writeByte(6)
      ..write(obj.codeStr);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NaviScanCodeEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
