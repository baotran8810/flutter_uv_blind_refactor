import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/app_hive.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/scan_code_dao/scan_code_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/doc_scan_code_entity/doc_scan_code_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/facility_scan_code_entity/facility_scan_code_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/navi_scan_code_entity/navi_scan_code_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/doc_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/facility_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/navi_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ScanCodeDaoImpl implements ScanCodeDao {
  final Box<DocScanCodeEntity> _docScanCodeBox;
  final Box<NaviScanCodeEntity> _naviScanCodeBox;
  final Box<FacilityScanCodeEntity> _facilityScanCodeBox;

  ScanCodeDaoImpl()
      : _docScanCodeBox = Get.find<AppHive>().getCodeBox<DocScanCodeEntity>(),
        _naviScanCodeBox = Get.find<AppHive>().getCodeBox<NaviScanCodeEntity>(),
        _facilityScanCodeBox =
            Get.find<AppHive>().getCodeBox<FacilityScanCodeEntity>();

  @override
  List<ScanCodeDto> getAllScanCodeList() {
    final scanCodeList = [
      ..._docScanCodeBox.values
          .map((scanCode) => DocScanCodeDto.fromEntity(scanCode))
          .toList(),
      ..._naviScanCodeBox.values
          .map((scanCode) => NaviScanCodeDto.fromEntity(scanCode))
          .toList(),
      ..._facilityScanCodeBox.values
          .map((scanCode) => FacilityScanCodeDto.fromEntity(scanCode))
          .toList(),
    ];
    scanCodeList.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    return scanCodeList;
  }

  @override
  ScanCodeDto? getScanCodeById(String id) {
    final List<ScanCodeDto> scanCodeList = getAllScanCodeList();
    return scanCodeList.firstWhereOrNull((scanCode) => scanCode.id == id);
  }

  @override
  Future<void> setScanCode(ScanCodeDto scanCode) async {
    switch (scanCode.codeType) {
      case ScanCodeType.doc:
        await _docScanCodeBox.put(
          scanCode.id,
          scanCode.toEntity() as DocScanCodeEntity,
        );
        break;
      case ScanCodeType.navi:
        await _naviScanCodeBox.put(
          scanCode.id,
          scanCode.toEntity() as NaviScanCodeEntity,
        );
        break;
      case ScanCodeType.facility:
        await _facilityScanCodeBox.put(
          scanCode.id,
          scanCode.toEntity() as FacilityScanCodeEntity,
        );
        break;
    }
  }

  @override
  Future<List<ScanCodeDto>> deleteScanCode(String id) async {
    await Future.wait([
      _docScanCodeBox.delete(id),
      _naviScanCodeBox.delete(id),
      _facilityScanCodeBox.delete(id),
    ]);
    return getAllScanCodeList();
  }
}
