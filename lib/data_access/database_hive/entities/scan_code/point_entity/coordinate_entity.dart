import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/base_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/hive_constants.dart';
import 'package:hive/hive.dart';

part 'coordinate_entity.g.dart';

@HiveType(typeId: HiveConst.coordinateInfoTid)
class CoordinateEntity extends BaseEntity {
  @HiveField(1)
  final double latitude;
  @HiveField(2)
  final double longitude;

  CoordinateEntity({
    required this.latitude,
    required this.longitude,
  });
}
