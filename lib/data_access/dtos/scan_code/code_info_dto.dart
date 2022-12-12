import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/miscs/code_info_entity.dart';

class CodeInfoDto {
  final String? codeId;
  final String? companyId;
  final String? projectId;
  final String? originalUrl;

  const CodeInfoDto({
    required this.codeId,
    required this.companyId,
    required this.projectId,
    required this.originalUrl,
  });

  factory CodeInfoDto.fromEntity(CodeInfoEntity entity) {
    return CodeInfoDto(
        codeId: entity.codeId,
        companyId: entity.companyId,
        projectId: entity.projectId,
        originalUrl: entity.originalUrl);
  }

  CodeInfoEntity toEntity() {
    return CodeInfoEntity(
      codeId: codeId,
      companyId: companyId,
      projectId: projectId,
      originalUrl: originalUrl,
    );
  }
}
