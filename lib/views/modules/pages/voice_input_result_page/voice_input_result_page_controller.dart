import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';

abstract class VoiceInputResultPageController {
  List<ScanCodeDto> get scanCodeList;

  String craftSearchResultOutput();
  Future<void> readNextFile();
}
