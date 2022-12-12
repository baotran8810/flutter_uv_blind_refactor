import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notification_app_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notifications_info_dto.dart';

abstract class NotificationRepository {
  Future<List<NotificationAppDto>?> getNotificationList({
    required int skip,
    required int limit,
  });

  Future<NotificationsInfoDto> getNotificationsInfo();
  Future<void> deleteAllNotifications();
  Future<void> readAllNotifications();
  Future<void> deleteNotification(int id);
  Future<void> readNotification(int id);
  Future<void> likeNotification({
    required int id,
    required String? userId,
    required void Function() logEventHandler,
  });
  Future<void> unlikeNotification(int id);
  Future<int> getNotificationLikeCount(int id);
}
