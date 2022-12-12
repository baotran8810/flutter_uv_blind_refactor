// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_info_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CodeInfoEntityAdapter extends TypeAdapter<CodeInfoEntity> {
  @override
  final int typeId = 12;

  @override
  CodeInfoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CodeInfoEntity(
      codeId: fields[0] as String?,
      companyId: fields[1] as String?,
      projectId: fields[2] as String?,
      originalUrl: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CodeInfoEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.codeId)
      ..writeByte(1)
      ..write(obj.companyId)
      ..writeByte(2)
      ..write(obj.projectId)
      ..writeByte(3)
      ..write(obj.originalUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CodeInfoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
