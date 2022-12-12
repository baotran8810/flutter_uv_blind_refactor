import 'package:flutter_uv_blind_refactor/data_access/database_hive/hive_constants.dart';
import 'package:hive/hive.dart';

part 'code_info_entity.g.dart';

@HiveType(typeId: HiveConst.codeInfoTid)
class CodeInfoEntity {
  @HiveField(0)
  final String? codeId;
  @HiveField(1)
  final String? companyId;
  @HiveField(2)
  final String? projectId;
  @HiveField(3)
  final String? originalUrl;

  CodeInfoEntity({
    required this.codeId,
    required this.companyId,
    required this.projectId,
    required this.originalUrl,
  });
}
