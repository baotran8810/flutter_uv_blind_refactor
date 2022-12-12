import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/base_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/hive_constants.dart';
import 'package:hive/hive.dart';

import 'coordinate_entity.dart';

part 'point_entity.g.dart';

@HiveType(typeId: HiveConst.pointEntityTid)
class PointEntity extends BaseEntity {
  @HiveField(1)
  final String pointName;
  @HiveField(2)
  final String? pointInfo;
  @HiveField(3)
  final String? beaconId;
  @HiveField(4)
  final CoordinateEntity coordinate;
  @HiveField(5)
  final List<String> categoryList;

  PointEntity({
    required this.pointName,
    required this.pointInfo,
    required this.beaconId,
    required this.coordinate,
    required this.categoryList,
  });
}
