import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/facility_scan_code_entity/facility_scan_code_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/code_info_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';

class FacilityScanCodeDto extends ScanCodeDto {
  final List<PointDto> pointList;

  FacilityScanCodeDto({
    String? id,
    required String brochureName,
    bool isBookmark = false,
    DateTime? createdDate,
    required CodeInfoDto? codeInfo,
    required String? codeStr,
    required this.pointList,
  }) : super(
          codeType: ScanCodeType.facility,
          id: id,
          name: brochureName,
          isBookmark: isBookmark,
          createdDate: createdDate,
          codeInfo: codeInfo,
          codeStr: codeStr,
        );

  factory FacilityScanCodeDto.fromEntity(FacilityScanCodeEntity entity) {
    return FacilityScanCodeDto(
      id: entity.id,
      brochureName: entity.name,
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
