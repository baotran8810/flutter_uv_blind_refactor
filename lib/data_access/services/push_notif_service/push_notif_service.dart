import 'package:flutter_uv_blind_refactor/data_access/dtos/address/address_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/analytics_service/analytics_service.dart';

enum NotificationStatus {
  success,
  fail,
  notAllowed,
}

abstract class PushNotifService {
  void initListeners({
    required AnalyticsService analyticsService,
    required void Function(Map<String, dynamic> rawPayload)
        onNotificationReceivedInForeground,
    required void Function(Map<String, dynamic> rawPayload)
        onNotificationOpened,
  });
  void requestNotificationPermission();
  void updateLocation(TagData data);
  Future<String?> getOsUserId();
}
