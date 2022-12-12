import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';

abstract class ScanCodeDao {
  List<ScanCodeDto> getAllScanCodeList();
  ScanCodeDto? getScanCodeById(String id);

  Future<void> setScanCode(ScanCodeDto scanCode);
  Future<List<ScanCodeDto>> deleteScanCode(String id);
}
