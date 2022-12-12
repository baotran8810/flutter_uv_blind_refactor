import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/miscs/code_info_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

abstract class ScanCodeEntity {
  @HiveField(0)
  final String id;

  /// Date applied read all
  @HiveField(1)
  final String name;

  /// Date applied delete all
  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final ScanCodeType codeType;

  @HiveField(4)
  final bool isBookmark;

  @HiveField(5)
  final CodeInfoEntity? codeInfo;

  /// Nullable because of migration
  @HiveField(6)
  final String? codeStr;

  ScanCodeEntity({
    String? id,
    required this.name,
    required this.date,
    required this.codeType,
    required this.isBookmark,
    required this.codeInfo,
    required this.codeStr,
  }) : id = id ?? const Uuid().v4();
}
