import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';

abstract class ScanCodeSqlDao {
  Future<void> addScanCodeList(List<ScanCodeDto> scanCodeList);
  Future<void> addScanCode(ScanCodeDto scanCode);
  Future<void> updateScanCode(String id, ScanCodeDto scanCode);
  Future<void> deleteScanCode(String id);
}
