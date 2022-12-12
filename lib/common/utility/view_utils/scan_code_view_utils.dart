import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/doc_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/facility_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/navi_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/facility_main_page/facility_main_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/mixed_code_list_page/mixed_code_list_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/navi_menu_page/navi_menu_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/reading_page/reading_page.dart';
import 'package:get/get.dart';

class ScanCodeViewUtils {
  static Future<void> _navigateTo(String page, {dynamic arguments}) async {
    await Get.toNamed(
      page,
      arguments: arguments,
      preventDuplicates: false,
    );
  }

  /// [scanCodeList] cannot be empty. This case should be handled before calling this
  static Future<void> goToScanCodePage(List<ScanCodeDto> scanCodeList,
      {String? signLanguageURL}) async {
    if (scanCodeList.isEmpty) {
      throw Exception(
        'Custom: scanCodeList cannot be empty. Must handle outside this function',
      );
    }

    if (scanCodeList.length > 1) {
      // Mixed code
      await _navigateTo(
        AppRoutes.mixedCodeList,
        arguments: MixedCodeListPageArguments(
          scanCodeList: scanCodeList,
        ),
      );
      return;
    }

    // Only have 1 scanCode
    final ScanCodeDto scanCode = scanCodeList[0];
    if (scanCode is NaviScanCodeDto) {
      await _navigateTo(
        AppRoutes.naviMenu,
        arguments: NaviMenuPageArguments(
          naviScanCode: scanCode,
        ),
      );
      return;
    }
    if (scanCode is FacilityScanCodeDto) {
      await _navigateTo(
        AppRoutes.facilityMain,
        arguments: FacilityMainPageArguments(
          facilityScanCode: scanCode,
        ),
      );
      return;
    }
    if (scanCode is DocScanCodeDto) {
      await _navigateTo(
        AppRoutes.reading,
        arguments: ReadingPageArguments(
            docScanCode: scanCode, signLanguageURL: signLanguageURL),
      );
      return;
    }

    throw Exception(
      'Custom: Cannot recognize scanCode, therefore cannot navigate',
    );
  }
}
