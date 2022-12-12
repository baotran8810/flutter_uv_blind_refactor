import 'package:flutter_uv_blind_refactor/common/config/environments.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/address/address_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/analytics_service/analytics_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/push_notif_service/push_notif_service.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class PushNotifServiceImpl implements PushNotifService {
  final AnalyticsService analyticsService = Get.find<AnalyticsService>();

  PushNotifServiceImpl() {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId(appEnvData.oneSignalAppId);
  }

  @override
  void initListeners({
    required AnalyticsService analyticsService,
    required void Function(Map<String, dynamic> rawPayload)
        onNotificationReceivedInForeground,
    required void Function(Map<String, dynamic> rawPayload)
        onNotificationOpened,
  }) {
    // TODO add setNotificationReceivedHandler after this issue was resolved
    // https://github.com/OneSignal/OneSignal-Flutter-SDK/issues/437

    // Will be called whenever a notification is received in foreground
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);

      final rawPayload = event.notification.rawPayload;

      if (rawPayload != null) {
        onNotificationReceivedInForeground(rawPayload);
      }
    });

    // Will be called whenever a notification is opened/button pressed.
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      final rawPayload = result.notification.rawPayload;

      if (rawPayload != null) {
        onNotificationOpened(rawPayload);
      }
    });

    // Will be called whenever the permission changes
    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      if (changes.to.status != OSNotificationPermission.authorized) {
        analyticsService.setPushStatusProperty(PushStatus.notAllowed);
      }
    });

    // Will be called whenever the subscription changes
    // (ie. user gets registered with OneSignal and gets a user ID)
    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      if (changes.to.subscribed) {
        analyticsService.setPushStatusProperty(PushStatus.success);
      } else {
        analyticsService.setPushStatusProperty(PushStatus.fail);
      }
    });
  }

  @override
  void requestNotificationPermission() {
    OneSignal.shared.promptUserForPushNotificationPermission();
  }

  @override
  void updateLocation(TagData data) {
    OneSignal.shared.sendTags(data.toJson());
  }

  @override
  Future<String?> getOsUserId() async {
    final deviceState = await OneSignal.shared.getDeviceState();

    return deviceState?.userId;
  }
}
