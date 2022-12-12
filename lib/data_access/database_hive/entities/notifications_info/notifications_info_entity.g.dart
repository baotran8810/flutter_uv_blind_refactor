// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_info_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationsInfoEntityAdapter
    extends TypeAdapter<NotificationsInfoEntity> {
  @override
  final int typeId = 0;

  @override
  NotificationsInfoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationsInfoEntity(
      dateRead: fields[1] as DateTime,
      dateDeleted: fields[2] as DateTime,
      notificationIdListRead: (fields[3] as List).cast<int>(),
      notificationIdListDeleted: (fields[4] as List).cast<int>(),
      notificationIdWithLikeId: (fields[5] as Map).cast<int, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, NotificationsInfoEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.dateRead)
      ..writeByte(2)
      ..write(obj.dateDeleted)
      ..writeByte(3)
      ..write(obj.notificationIdListRead)
      ..writeByte(4)
      ..write(obj.notificationIdListDeleted)
      ..writeByte(5)
      ..write(obj.notificationIdWithLikeId)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationsInfoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
