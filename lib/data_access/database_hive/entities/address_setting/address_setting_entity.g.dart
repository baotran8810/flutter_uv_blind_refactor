// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_setting_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressSettingEntityAdapter extends TypeAdapter<AddressSettingEntity> {
  @override
  final int typeId = 2;

  @override
  AddressSettingEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddressSettingEntity(
      currentAddress: (fields[1] as Map?)?.cast<String, dynamic>(),
      currentAddressName: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AddressSettingEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.currentAddress)
      ..writeByte(2)
      ..write(obj.currentAddressName)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressSettingEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
