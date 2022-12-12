import 'package:flutter_uv_blind_refactor/common/utility/utils/cold_start_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/deep_link_handler_view_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/push_notif_handler_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/notification_repository/notification_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/scan_code_repository/scan_code_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/analytics_service/analytics_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/push_notif_service/push_notif_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/scan_decode_service/scan_decode_service.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/app_info_controller/app_info_controller.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/notifications_controller/notifications_controller.dart';

abstract class StartupViewUtils {
  static void initStartup({
    required NotificationRepository notificationRepository,
    required ScanCodeRepository scanCodeRepository,
    required AnalyticsService analyticsService,
    required PushNotifService pushNotifService,
    required ScanDecodeService scanDecodeService,
    required AppInfoController appInfoController,
    required NotificationsController notificationsController,
  }) {
    // Check to avoid calling this multiple times
    if (ColdStartUtils.isAppInit) {
      return;
    }

    ColdStartUtils.isAppInit = true;

    appInfoController.init();
    notificationsController.refreshNotificationList();

    // * For push notif
    pushNotifService.initListeners(
      analyticsService: analyticsService,
      onNotificationReceivedInForeground: (rawPayload) {
        PushNotifHandlerViewUtils.handlePushNotifReceived(
          rawPayload: rawPayload,
          analyticsService: analyticsService,
          notificationsController: notificationsController,
        );
      },
      onNotificationOpened: (rawPayload) {
        // If opened from cold start: this will be called right after
        // the [initListeners()] is called

        PushNotifHandlerViewUtils.handlePushNotifOpened(
          rawPayload: rawPayload,
          notificationRepository: notificationRepository,
        );
      },
    );

    // * For deep link
    if (ColdStartUtils.scanCodeUrl != null) {
      DeepLinkHandlerViewUtils.handleScanCodeUrl(
        analyticsService: analyticsService,
        scanDecodeService: scanDecodeService,
        scanCodeRepository: scanCodeRepository,
        scanCodeUrl: ColdStartUtils.scanCodeUrl!,
      );
    }
  }
}
