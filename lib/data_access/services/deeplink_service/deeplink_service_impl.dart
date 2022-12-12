import 'package:flutter/services.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/cold_start_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/log_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/deep_link_handler_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/deeplink_service/deeplink_service.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';

class DeeplinkServiceImpl implements DeeplinkService {
  static const deeplinkMC = MethodChannel('uv_deeplink');

  DeeplinkServiceImpl() {
    // deeplinkMC.setMethodCallHandler(handler);
  }

  @override
  Future<void> init() async {
    _initColdStart();
    _initBackground();
  }

  Future<void> _initColdStart() async {
    try {
      final initialUri = await getInitialUri();
      if (initialUri == null) {
        return;
      }

      LogUtils.iNoST('Cold start with deep link: ${initialUri.toString()}');

      final String? link = initialUri.queryParameters['link'];

      ColdStartUtils.scanCodeUrl = link;
    } on PlatformException catch (e) {
      LogUtils.e('Deep link error', e);
    }
  }

  Future<void> _initBackground() async {
    uriLinkStream.listen((uri) {
      if (uri == null) {
        return;
      }

      LogUtils.iNoST('Background with deep link: ${uri.toString()}');

      final String? link = uri.queryParameters['link'];

      if (link != null) {
        DeepLinkHandlerViewUtils.handleScanCodeUrl(
          analyticsService: Get.find(),
          scanDecodeService: Get.find(),
          scanCodeRepository: Get.find(),
          scanCodeUrl: link,
        );
      }
    }, onError: (e) {
      LogUtils.e('Deep link error', e);
    });
  }
}
