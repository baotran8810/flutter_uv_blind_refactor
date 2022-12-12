// ignore_for_file: use_setters_to_change_properties

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/doc_scan_code_entity/doc_scan_code_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/facility_scan_code_entity/facility_scan_code_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/navi_scan_code_entity/navi_scan_code_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/scan_code_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_sqlite/database_sqlite.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/code_info_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/doc_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/facility_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/navi_scan_code_dto.dart';
import 'package:uuid/uuid.dart';

abstract class ScanCodeDto {
  String id;
  final ScanCodeType codeType;
  String name;
  bool isBookmark;
  final DateTime createdDate;
  final CodeInfoDto? codeInfo;
  final String? codeStr;

  ScanCodeDto({
    String? id,
    required this.codeType,
    required this.name,
    this.isBookmark = false,
    DateTime? createdDate,
    required this.codeInfo,
    required this.codeStr,
  })  : id = id ?? Uuid().v4(),
        createdDate = createdDate ?? DateTime.now();

  /// Mutate
  void setName(String name) {
    this.name = name;
  }

  /// Mutate
  void setIsBookmark(bool isBookmark) {
    this.isBookmark = isBookmark;
  }

  String getSearchContent() {
    final scanCode = this;
    // Search by points' name
    if (scanCode is FacilityScanCodeDto) {
      final List<String> pointNameList =
          scanCode.pointList.map((point) => point.pointName).toList();
      return pointNameList.join(' ');
    }
    // Search by points' name
    else if (scanCode is NaviScanCodeDto) {
      final List<String> pointNameList =
          scanCode.pointList.map((point) => point.pointName).toList();
      return pointNameList.join(' ');
    }
    // Search by reading content
    else if (scanCode is DocScanCodeDto) {
      final List<String> contentList =
          scanCode.langKeyWithContent.values.toList();
      return contentList.join(' ');
    } else {
      throw Exception('Custom: Missing scanCode type check');
    }
  }

  ScanCodeEntity toEntity() {
    final scanCode = this;
    if (scanCode is FacilityScanCodeDto) {
      return FacilityScanCodeEntity(
        id: id,
        name: name,
        codeType: codeType,
        date: createdDate,
        isBookmark: isBookmark,
        codeInfo: codeInfo?.toEntity(),
        codeStr: codeStr,
        pointList: scanCode.pointList.map((point) => point.toEntity()).toList(),
      );
    } else if (scanCode is NaviScanCodeDto) {
      return NaviScanCodeEntity(
        id: id,
        name: name,
        codeType: codeType,
        date: createdDate,
        isBookmark: isBookmark,
        codeInfo: codeInfo?.toEntity(),
        codeStr: codeStr,
        pointList: scanCode.pointList.map((point) => point.toEntity()).toList(),
      );
    } else if (scanCode is DocScanCodeDto) {
      return DocScanCodeEntity(
        id: id,
        name: name,
        codeType: codeType,
        date: createdDate,
        isBookmark: isBookmark,
        codeInfo: codeInfo?.toEntity(),
        codeStr: codeStr,
        langKeyWithContent: scanCode.langKeyWithContent,
        hasSyncOnline: scanCode.hasSyncOnline,
      );
    } else {
      throw Exception('Custom: Missing scanCode type check');
    }
  }

  ScanCodeSqlEntitiesCompanion toSqlCompanion() {
    final scanCode = this;
    Map<String, String>? langKeyWithContent;
    if (scanCode is DocScanCodeDto) {
      langKeyWithContent = scanCode.langKeyWithContent;
    }

    return ScanCodeSqlEntitiesCompanion.insert(
      id: id,
      title: name,
      date: createdDate,
      codeType: codeType,
      isBookmark: isBookmark,
      langKeyWithContentMapJson: Value(
        langKeyWithContent != null ? jsonEncode(langKeyWithContent) : null,
      ),
    );
  }
}
