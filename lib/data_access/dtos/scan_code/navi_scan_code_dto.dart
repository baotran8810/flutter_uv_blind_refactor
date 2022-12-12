import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/navi_scan_code_entity/navi_scan_code_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/code_info_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';

class NaviScanCodeDto extends ScanCodeDto {
  List<PointDto> pointList;

  NaviScanCodeDto({
    String? id,
    required String courseName,
    bool isBookmark = false,
    DateTime? createdDate,
    required CodeInfoDto? codeInfo,
    required String? codeStr,
    required this.pointList,
  }) : super(
          codeType: ScanCodeType.navi,
          id: id,
          name: courseName,
          isBookmark: isBookmark,
          createdDate: createdDate,
          codeInfo: codeInfo,
          codeStr: codeStr,
        );

  void revertPointList() {
    pointList = pointList.reversed.toList();
  }

  factory NaviScanCodeDto.fromEntity(NaviScanCodeEntity entity) {
    return NaviScanCodeDto(
      id: entity.id,
      courseName: entity.name,
      pointList: entity.pointList
          .map((pointEntity) => PointDto.fromEntity(pointEntity))
          .toList(),
      createdDate: entity.date,
      isBookmark: entity.isBookmark,
      codeInfo: entity.codeInfo != null
          ? CodeInfoDto.fromEntity(entity.codeInfo!)
          : null,
      codeStr: entity.codeStr,
    );
  }
}
