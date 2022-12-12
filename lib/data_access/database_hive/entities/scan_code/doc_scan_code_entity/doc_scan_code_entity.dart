import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/miscs/code_info_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/scan_code_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/hive_constants.dart';
import 'package:hive/hive.dart';

part 'doc_scan_code_entity.g.dart';

@HiveType(typeId: HiveConst.docScanCodeTid)
class DocScanCodeEntity extends ScanCodeEntity {
  @HiveField(101)
  final Map<String, String> langKeyWithContent;

  @HiveField(102, defaultValue: false)
  final bool hasSyncOnline;

  DocScanCodeEntity({
    required String id,
    required String name,
    required ScanCodeType codeType,
    required DateTime date,
    required bool isBookmark,
    required CodeInfoEntity? codeInfo,
    required String? codeStr,
    required this.langKeyWithContent,
    required this.hasSyncOnline,
  }) : super(
          id: id,
          name: name,
          codeType: codeType,
          date: date,
          codeInfo: codeInfo,
          codeStr: codeStr,
          isBookmark: isBookmark,
        );
}
