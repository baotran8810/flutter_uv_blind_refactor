import 'package:flutter_uv_blind_refactor/common/utility/view_utils/scan_code_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/doc_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/facility_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/navi_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/scan_code_repository/scan_code_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/analytics_service/analytics_service.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/file_list_page/file_list_page_controller.dart';
import 'package:get/get.dart';

class FileListPageControllerImpl extends GetxController
    implements FileListPageController {
  final AnalyticsService _analyticsService;
  final ScanCodeRepository _scanCodeRepository;

  FileListPageControllerImpl({
    required AnalyticsService analyticsService,
    required ScanCodeRepository scanCodeRepository,
  })  : _analyticsService = analyticsService,
        _scanCodeRepository = scanCodeRepository;

  final Rx<List<ScanCodeDto>> _scanCodeList = Rx([]);
  @override
  List<ScanCodeDto> get scanCodeList => _scanCodeList.value;

  final Rx<FileFilter?> _selectedFilter = Rx(null);
  @override
  FileFilter? get selectedFilter => _selectedFilter.value;

  @override
  void onInit() {
    super.onInit();

    _fetchAllScanCodes();
  }

  void _fetchAllScanCodes() {
    _scanCodeList.value = _scanCodeRepository.getAllScanCode();
  }

  @override
  Future<void> goToPage(ScanCodeDto scanCodeDto) async {
    _analyticsService.logOpenFile(
      codeName: scanCodeDto.name,
      codeInfo: scanCodeDto.codeInfo,
    );
    await ScanCodeViewUtils.goToScanCodePage([scanCodeDto]);
    _fetchScanCodeListByCurrentFilter();
  }

  @override
  void toggleFilter(FileFilter filter) {
    if (selectedFilter == filter) {
      _selectedFilter.value = null;
    } else {
      _selectedFilter.value = filter;
    }

    _fetchScanCodeListByCurrentFilter();
  }

  void _fetchScanCodeListByCurrentFilter() {
    final allScanCodes = _scanCodeRepository.getAllScanCode();
    final filter = selectedFilter;

    if (filter == null) {
      _scanCodeList.value = List.from(allScanCodes);
    } else {
      _scanCodeList.value = allScanCodes.where((scanCode) {
        switch (filter) {
          case FileFilter.doc:
            return scanCode is DocScanCodeDto;
          case FileFilter.navi:
            return scanCode is NaviScanCodeDto;
          case FileFilter.facility:
            return scanCode is FacilityScanCodeDto;
          case FileFilter.bookmark:
            return scanCode.isBookmark;
        }
      }).toList();
    }
  }
}
