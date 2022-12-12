import 'package:flutter_uv_blind_refactor/common/utility/view_utils/loading_view_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/scan_code_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/scan_code_repository/scan_code_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/analytics_service/analytics_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/scan_decode_service/scan_decode_service.dart';

class DeepLinkHandlerViewUtils {
  static Future<void> handleScanCodeUrl({
    required AnalyticsService analyticsService,
    required ScanDecodeService scanDecodeService,
    required ScanCodeRepository scanCodeRepository,
    required String scanCodeUrl,
  }) async {
    await LoadingViewUtils.showLoading();

    final decodeResult = await scanDecodeService.decodeFromUrl(
      scanCodeUrl,
      logEventHandler: null,
    );

    if (decodeResult == null) {
      await LoadingViewUtils.hideLoading();
      return;
    }

    await scanCodeRepository.addOrUpdateScanCodeList(decodeResult.scanCodeList);
    await LoadingViewUtils.hideLoading();

    ScanCodeViewUtils.goToScanCodePage(decodeResult.scanCodeList);
  }
}
