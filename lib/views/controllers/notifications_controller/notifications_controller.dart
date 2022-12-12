import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notification_app_dto.dart';

abstract class NotificationsController {
  bool get isLoading;
  List<NotificationAppDto> get notificationList;
  bool get hasAnyUnread;

  Future<void> refreshNotificationList();
  Future<void> loadMore();

  void goToNotificationDetail(int id);

  Future<void> markAsReadNotification(int id);
  Future<bool> deleteNotification(int id);

  Future<void> markAllAsReadNotifications();
  Future<void> deleteAllNotifications();
}
