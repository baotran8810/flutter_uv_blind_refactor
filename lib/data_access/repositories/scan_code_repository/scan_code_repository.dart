import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/doc_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';

abstract class ScanCodeRepository {
  Future<void> updateName(String id, String name);
  Future<void> updateIsBookmark(String id);
  Future<List<ScanCodeDto>> addOrUpdateScanCodeList(List<ScanCodeDto> codeList);
  List<ScanCodeDto> getAllScanCode();
  Future<List<ScanCodeDto>> deleteScanCode(String id);

  /// Get online content from API, then save to local db & return new object
  Future<DocScanCodeDto> syncDocScanCode(DocScanCodeDto docScanCode);
}
