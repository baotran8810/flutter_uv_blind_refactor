import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';

abstract class ScanDecodeService {
  Future<CodeDecodeResult?> decodeFromString(
    String codeStr, {
    String? legacyDocCodeLangKey,
    DateTime? createdDate,
    required void Function(ScanCodeDto)? logEventHandler,
  });
  Future<CodeDecodeResult?> decodeFromUrl(
    String url, {
    required void Function(ScanCodeDto)? logEventHandler,
  });
}

class CodeDecodeResult {
  /// Cannot be empty
  final List<ScanCodeDto> scanCodeList;

  CodeDecodeResult({
    required this.scanCodeList,
  });
}
