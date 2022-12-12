import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/miscs/code_info_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/point_entity/point_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/scan_code_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/hive_constants.dart';
import 'package:hive/hive.dart';

part 'navi_scan_code_entity.g.dart';

const String uniqueId = 'UNIQUE';

@HiveType(typeId: HiveConst.naviScanCodeTid)
class NaviScanCodeEntity extends ScanCodeEntity {
  @HiveField(101)
  final List<PointEntity> pointList;

  NaviScanCodeEntity({
    required String id,
    required String name,
    required ScanCodeType codeType,
    required DateTime date,
    required bool isBookmark,
    required CodeInfoEntity? codeInfo,
    required String? codeStr,
    required this.pointList,
  }) : super(
          id: id,
          name: name,
          codeType: codeType,
          date: date,
          isBookmark: isBookmark,
          codeInfo: codeInfo,
          codeStr: codeStr,
        );
}
