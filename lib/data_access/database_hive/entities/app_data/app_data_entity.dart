import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/base_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/hive_constants.dart';
import 'package:hive/hive.dart';

part 'app_data_entity.g.dart';

const String uniqueId = 'UNIQUE';

@HiveType(typeId: HiveConst.appDataTid)
class AppDataEntity extends BaseEntity {
  @HiveField(1)
  final bool isOnboardCompleted;

  @HiveField(2)
  final DateTime pollyLastModifiedAt;

  @HiveField(3)
  final String signLanguageId;

  @HiveField(4)
  final bool? hasMigratedFromOldApp;

  AppDataEntity({
    required this.isOnboardCompleted,
    required this.pollyLastModifiedAt,
    required this.signLanguageId,
    required this.hasMigratedFromOldApp,
  }) : super(id: uniqueId);
}
