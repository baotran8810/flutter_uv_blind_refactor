import 'dart:convert';
import 'dart:io';

import 'package:flutter_uv_blind_refactor/common/utility/utils/log_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notification_app_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notification_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/notification_repository/notification_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/analytics_service/analytics_service.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/notifications_controller/notifications_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/notification_detail_page/notification_detail_page.dart';
import 'package:get/get.dart';

class PushNotifHandlerViewUtils {
  static Future<void> handlePushNotifReceived({
    required Map<String, dynamic> rawPayload,
    required AnalyticsService analyticsService,
    required NotificationsController notificationsController,
  }) async {
    final notification = _parseToRawNotification(rawPayload);
    if (notification != null) {
      notificationsController.refreshNotificationList();

      // Analytics
      analyticsService.logPushAction(
        action: PushAction.received,
        title: notification.getTitle(),
        messageId: notification.id,
        companyName: notification.company?.companyName,
      );
    }
  }

  static Future<void> handlePushNotifOpened({
    required Map<String, dynamic> rawPayload,
    required NotificationRepository notificationRepository,
  }) async {
    final notification = _parseToRawNotification(rawPayload);

    if (notification == null) {
      return;
    }

    final notificationAppDto =
        NotificationAppDto.fromRawDto(rawDto: notification);

    final notificationsInfo =
        await notificationRepository.getNotificationsInfo();

    notificationAppDto.applyNotificationsInfo(notificationsInfo);

    Get.toNamed(
      AppRoutes.notificationDetail,
      arguments: NotificationDetailPageArguments(
        notification: notificationAppDto,
      ),
    );
  }

  static NotificationDto? _parseToRawNotification(
    Map<String, dynamic> rawPayload,
  ) {
    try {
      // 1: Try to parse to NotificationDto from rawPayload
      // ! Somehow, response on Android is json string,
      // ! while on iOS, it's json
      final customJson = Platform.isAndroid
          ? jsonDecode(rawPayload['custom'] as String) as Map<String, dynamic>
          : rawPayload['custom'] as Map<String, dynamic>;
      final notificationJson = customJson['a'] as Map<String, dynamic>;

      return NotificationDto.fromJson(notificationJson);
    } catch (e) {
      LogUtils.e('Failed to parse rawPayload', e);
      return null;
    }
  }
}
