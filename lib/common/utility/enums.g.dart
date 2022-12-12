// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScanCodeTypeAdapter extends TypeAdapter<ScanCodeType> {
  @override
  final int typeId = 8;

  @override
  ScanCodeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ScanCodeType.navi;
      case 1:
        return ScanCodeType.facility;
      case 2:
        return ScanCodeType.doc;
      default:
        return ScanCodeType.navi;
    }
  }

  @override
  void write(BinaryWriter writer, ScanCodeType obj) {
    switch (obj) {
      case ScanCodeType.navi:
        writer.writeByte(0);
        break;
      case ScanCodeType.facility:
        writer.writeByte(1);
        break;
      case ScanCodeType.doc:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanCodeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GenderAdapter extends TypeAdapter<Gender> {
  @override
  final int typeId = 10;

  @override
  Gender read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Gender.male;
      case 1:
        return Gender.female;
      default:
        return Gender.male;
    }
  }

  @override
  void write(BinaryWriter writer, Gender obj) {
    switch (obj) {
      case Gender.male:
        writer.writeByte(0);
        break;
      case Gender.female:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppVoiceAdapter extends TypeAdapter<AppVoice> {
  @override
  final int typeId = 13;

  @override
  AppVoice read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppVoice.device;
      case 1:
        return AppVoice.univoice;
      default:
        return AppVoice.device;
    }
  }

  @override
  void write(BinaryWriter writer, AppVoice obj) {
    switch (obj) {
      case AppVoice.device:
        writer.writeByte(0);
        break;
      case AppVoice.univoice:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppVoiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
