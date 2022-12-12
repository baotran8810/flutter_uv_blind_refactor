import 'package:flutter_uv_blind_refactor/data_access/database_hive/app_hive.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/notifications_info_dao/notifications_info_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/notifications_info/notifications_info_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notifications_info_dto.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class NotificationsInfoDaoImpl implements NotificationsInfoDao {
  final Box<NotificationsInfoEntity> _notifInfosBox;

  NotificationsInfoDaoImpl()
      : _notifInfosBox = Get.find<AppHive>().getBox<NotificationsInfoEntity>() {
    // Init a record in db
    getNotificationsInfo();
  }

  Future<NotificationsInfoDto> _saveInfo(NotificationsInfoDto dto) async {
    await _notifInfosBox.put(uniqueId, dto.toEntity());
    return NotificationsInfoDto.fromEntity(_notifInfosBox.values.first);
  }

  @override
  Future<NotificationsInfoDto> getNotificationsInfo() async {
    if (_notifInfosBox.values.isEmpty) {
      return await _saveInfo(
        NotificationsInfoDto.initDefault(),
      );
    }

    return NotificationsInfoDto.fromEntity(_notifInfosBox.values.first);
  }

  @override
  Future<NotificationsInfoDto> setDateDeletedNow() async {
    final notifInfoDto = await getNotificationsInfo();
    notifInfoDto.dateDeleted = DateTime.now();
    return _saveInfo(notifInfoDto);
  }

  @override
  Future<NotificationsInfoDto> setDateReadNow() async {
    final notifInfoDto = await getNotificationsInfo();
    notifInfoDto.dateRead = DateTime.now();
    return _saveInfo(notifInfoDto);
  }

  @override
  Future<NotificationsInfoDto> addNotificationIdToDelete(int id) async {
    final notifInfoDto = await getNotificationsInfo();
    notifInfoDto.notificationIdListDeleted.add(id);
    return _saveInfo(notifInfoDto);
  }

  @override
  Future<NotificationsInfoDto> addNotificationIdToRead(int id) async {
    final notifInfoDto = await getNotificationsInfo();
    notifInfoDto.notificationIdListRead.add(id);
    return _saveInfo(notifInfoDto);
  }

  @override
  Future<NotificationsInfoDto> addNotificationIdToLiked({
    required int notificationId,
    required String likeId,
  }) async {
    final notifInfoDto = await getNotificationsInfo();
    notifInfoDto.notificationIdWithLikeId[notificationId] = likeId;
    return _saveInfo(notifInfoDto);
  }

  @override
  Future<NotificationsInfoDto> removeNotificationIdFromLiked({
    required int notificationId,
  }) async {
    final notifInfoDto = await getNotificationsInfo();
    notifInfoDto.notificationIdWithLikeId.remove(notificationId);
    return _saveInfo(notifInfoDto);
  }
}
