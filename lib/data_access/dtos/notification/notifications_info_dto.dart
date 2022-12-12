import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/notifications_info/notifications_info_entity.dart';

class NotificationsInfoDto {
  DateTime dateRead;
  DateTime dateDeleted;
  List<int> notificationIdListRead;
  List<int> notificationIdListDeleted;
  Map<int, String> notificationIdWithLikeId;

  NotificationsInfoDto({
    required this.dateRead,
    required this.dateDeleted,
    required this.notificationIdListRead,
    required this.notificationIdListDeleted,
    required this.notificationIdWithLikeId,
  });

  factory NotificationsInfoDto.initDefault() {
    return NotificationsInfoDto(
      dateRead: DateTime.now(),
      dateDeleted: DateTime(1700),
      notificationIdListRead: [],
      notificationIdListDeleted: [],
      notificationIdWithLikeId: {},
    );
  }

  factory NotificationsInfoDto.fromEntity(NotificationsInfoEntity entity) {
    return NotificationsInfoDto(
      dateRead: entity.dateRead,
      dateDeleted: entity.dateDeleted,
      notificationIdListRead: entity.notificationIdListRead,
      notificationIdListDeleted: entity.notificationIdListDeleted,
      notificationIdWithLikeId: entity.notificationIdWithLikeId,
    );
  }

  NotificationsInfoEntity toEntity() {
    return NotificationsInfoEntity(
      dateRead: dateRead,
      dateDeleted: dateDeleted,
      notificationIdListRead: notificationIdListRead,
      notificationIdListDeleted: notificationIdListDeleted,
      notificationIdWithLikeId: notificationIdWithLikeId,
    );
  }
}
