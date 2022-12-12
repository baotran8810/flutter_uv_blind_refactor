import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notifications_info_dto.dart';

abstract class NotificationsInfoDao {
  Future<NotificationsInfoDto> getNotificationsInfo();

  Future<NotificationsInfoDto> setDateDeletedNow();
  Future<NotificationsInfoDto> setDateReadNow();
  Future<NotificationsInfoDto> addNotificationIdToDelete(int id);
  Future<NotificationsInfoDto> addNotificationIdToRead(int id);
  Future<NotificationsInfoDto> addNotificationIdToLiked({
    required int notificationId,
    required String likeId,
  });
  Future<NotificationsInfoDto> removeNotificationIdFromLiked({
    required int notificationId,
  });
}
