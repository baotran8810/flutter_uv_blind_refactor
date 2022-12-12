// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_scan_code_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DocScanCodeEntityAdapter extends TypeAdapter<DocScanCodeEntity> {
  @override
  final int typeId = 3;

  @override
  DocScanCodeEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DocScanCodeEntity(
      id: fields[0] as String,
      name: fields[1] as String,
      codeType: fields[3] as ScanCodeType,
      date: fields[2] as DateTime,
      isBookmark: fields[4] as bool,
      codeInfo: fields[5] as CodeInfoEntity?,
      codeStr: fields[6] as String?,
      langKeyWithContent: (fields[101] as Map).cast<String, String>(),
      hasSyncOnline: fields[102] == null ? false : fields[102] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DocScanCodeEntity obj) {
    writer
      ..writeByte(9)
      ..writeByte(101)
      ..write(obj.langKeyWithContent)
      ..writeByte(102)
      ..write(obj.hasSyncOnline)
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
      other is DocScanCodeEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
