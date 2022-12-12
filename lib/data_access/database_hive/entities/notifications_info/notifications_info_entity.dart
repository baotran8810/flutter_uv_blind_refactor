import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/base_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/hive_constants.dart';
import 'package:hive/hive.dart';

part 'notifications_info_entity.g.dart';

const String uniqueId = 'UNIQUE';

@HiveType(typeId: HiveConst.notificationsInfoTid)
class NotificationsInfoEntity extends BaseEntity {
  /// Date applied read all
  @HiveField(1)
  final DateTime dateRead;

  /// Date applied delete all
  @HiveField(2)
  final DateTime dateDeleted;

  @HiveField(3)
  final List<int> notificationIdListRead;

  @HiveField(4)
  final List<int> notificationIdListDeleted;

  @HiveField(5)
  final Map<int, String> notificationIdWithLikeId;

  NotificationsInfoEntity({
    required this.dateRead,
    required this.dateDeleted,
    required this.notificationIdListRead,
    required this.notificationIdListDeleted,
    required this.notificationIdWithLikeId,
  }) : super(id: uniqueId);
}
