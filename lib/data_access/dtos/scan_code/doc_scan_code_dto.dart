import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/doc_scan_code_entity/doc_scan_code_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/code_info_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';

part 'doc_scan_code_dto.g.dart';

@CopyWith()
class DocScanCodeDto extends ScanCodeDto {
  final Map<String, String> langKeyWithContent;
  final bool hasSyncOnline;

  DocScanCodeDto({
    String? id,
    required String name,
    bool isBookmark = false,
    DateTime? createdDate,
    required CodeInfoDto? codeInfo,
    required String? codeStr,
    required this.langKeyWithContent,
    required this.hasSyncOnline,
  }) : super(
          codeType: ScanCodeType.doc,
          id: id,
          name: name,
          isBookmark: isBookmark,
          createdDate: createdDate,
          codeInfo: codeInfo,
          codeStr: codeStr,
        );

  factory DocScanCodeDto.fromEntity(DocScanCodeEntity entity) {
    return DocScanCodeDto(
      id: entity.id,
      name: entity.name,
      langKeyWithContent: entity.langKeyWithContent,
      createdDate: entity.date,
      isBookmark: entity.isBookmark,
      codeInfo: entity.codeInfo != null
          ? CodeInfoDto.fromEntity(entity.codeInfo!)
          : null,
      codeStr: entity.codeStr,
      hasSyncOnline: entity.hasSyncOnline,
    );
  }
}
