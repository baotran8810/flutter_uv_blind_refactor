import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';

abstract class FileListPageController {
  List<ScanCodeDto> get scanCodeList;
  FileFilter? get selectedFilter;

  Future<void> goToPage(ScanCodeDto scanCodeDto);
  void toggleFilter(FileFilter filter);
}

// Order matters
enum FileFilter { doc, navi, facility, bookmark }
