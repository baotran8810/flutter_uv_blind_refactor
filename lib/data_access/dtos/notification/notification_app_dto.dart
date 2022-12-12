import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notification_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notifications_info_dto.dart';

/// `NotificationDto` with some extended mutable fields
/// to use in Controller/View layer
class NotificationAppDto extends NotificationDto {
  bool hasRead;
  bool hasLiked;

  NotificationAppDto({
    required this.hasRead,
    required this.hasLiked,
    required NotificationDto notificationDto,
  }) : super(
          id: notificationDto.id,
          companyId: notificationDto.companyId,
          localizedMessageList: notificationDto.localizedMessageList,
          webviewUrl: notificationDto.webviewUrl,
          qrCode: notificationDto.qrCode,
          lastPushAt: notificationDto.lastPushAt,
          likedCount: notificationDto.likedCount,
          company: notificationDto.company,
          attachmentList: notificationDto.attachmentList,
        );

  factory NotificationAppDto.fromRawDto({
    required NotificationDto rawDto,
  }) {
    return NotificationAppDto(
      hasRead: false,
      hasLiked: false,
      notificationDto: rawDto,
    );
  }

  /// ! Mutate
  void applyNotificationsInfo(NotificationsInfoDto notificationsInfo) {
    // hasRead = true for:
    // - All notifications which came before `dateRead` (read all notifs)
    // - All notifications inside `notificationIdListRead` (read 1 notif)
    hasRead = lastPushAt.compareTo(notificationsInfo.dateRead) <= 0 ||
        notificationsInfo.notificationIdListRead.contains(id);

    // hasLiked
    final likedNotificationIds =
        notificationsInfo.notificationIdWithLikeId.keys.toList();
    hasLiked = likedNotificationIds.contains(id);
  }
}
