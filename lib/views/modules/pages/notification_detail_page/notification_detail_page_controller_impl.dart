import 'package:flutter_uv_blind_refactor/common/utility/view_utils/loading_view_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/scan_code_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notification_app_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/notification_repository/notification_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/scan_code_repository/scan_code_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/analytics_service/analytics_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/push_notif_service/push_notif_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/scan_decode_service/scan_decode_service.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/notifications_controller/notifications_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/notification_detail_page/notification_detail_page_controller.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

class NotificationDetailPageControllerImpl extends GetxController
    implements NotificationDetailPageController {
  final AnalyticsService _analyticsService;
  final NotificationRepository _notificationRepository;
  final PushNotifService _notificationService;
  final ScanDecodeService _scanDecodeService;
  final ScanCodeRepository _scanCodeRepository;
  final NotificationsController _notificationsController;

  final NotificationAppDto notification;
  final void Function()? onToggledLike;

  NotificationDetailPageControllerImpl({
    required AnalyticsService analyticsService,
    required NotificationRepository notificationRepository,
    required PushNotifService notificationService,
    required ScanDecodeService scanDecodeService,
    required ScanCodeRepository scanCodeRepository,
    required NotificationsController notificationsController,
    required this.notification,
    required this.onToggledLike,
  })  : _analyticsService = analyticsService,
        _notificationRepository = notificationRepository,
        _notificationService = notificationService,
        _scanDecodeService = scanDecodeService,
        _scanCodeRepository = scanCodeRepository,
        _notificationsController = notificationsController;

  /// Like count in current session
  final Rx<int> _currentLikedCount = Rx(0);
  @override
  int get currentLikedCount => _currentLikedCount.value;

  final Rx<bool> _isLoadingLikedCount = Rx(false);
  @override
  bool get isLoadingLikedCount => _isLoadingLikedCount.value;

  /// Like status in current session
  final Rx<bool> _currentHasLiked = Rx(false);
  @override
  bool get currentHasLiked => _currentHasLiked.value;

  @override
  Future<void> onInit() async {
    super.onInit();

    if (!notification.hasRead) {
      _notificationsController.markAsReadNotification(notification.id);
      // Analytics
      _analyticsService.logOpenPush(
        title: notification.getTitle(),
        messageId: notification.id,
        companyName: notification.company?.companyName,
      );
    }

    _currentHasLiked.value = notification.hasLiked;
    await _fetchLikeCount();
  }

  Future<void> _fetchLikeCount() async {
    _isLoadingLikedCount.value = true;

    final int likeCount =
        await _notificationRepository.getNotificationLikeCount(notification.id);

    _isLoadingLikedCount.value = false;

    _currentLikedCount.value = likeCount;
  }

  @override
  Future<void> decodeScanCode() async {
    final String? link = notification.qrCode?.link;
    if (link == null) {
      return;
    }

    await LoadingViewUtils.showLoading();
    final decodeResult = await _scanDecodeService.decodeFromUrl(
      link,
      logEventHandler: (scanCode) {
        _analyticsService.logDecodeScanCode(
          decodeSource: DecodeSource.attachedCode,
          codeName: scanCode.name,
          codeInfo: scanCode.codeInfo,
        );
      },
    );

    if (decodeResult == null) {
      // TODO show error dialog
      await LoadingViewUtils.hideLoading();
      return;
    }

    await _scanCodeRepository
        .addOrUpdateScanCodeList(decodeResult.scanCodeList);
    await LoadingViewUtils.hideLoading();

    ScanCodeViewUtils.goToScanCodePage(decodeResult.scanCodeList);
  }

  @override
  Future<void> toggleLikeNotification() async {
    await LoadingViewUtils.showLoading();
    if (!currentHasLiked) {
      final String? userId = await _notificationService.getOsUserId();
      await _notificationRepository.likeNotification(
          id: notification.id,
          userId: userId,
          logEventHandler: () {
            _analyticsService.logLikePush(
              title: notification.getTitle(),
              messageId: notification.id,
              companyName: notification.company?.companyName,
            );
          });
      _currentLikedCount.value++;
      _currentHasLiked.value = true;
    } else {
      await _notificationRepository.unlikeNotification(notification.id);
      _currentLikedCount.value--;
      _currentHasLiked.value = false;
    }
    await LoadingViewUtils.hideLoading();

    onToggledLike?.call();
  }

  @override
  Future<void> shareNotification() async {
    await Share.share(notification.webviewUrl);
  }

  @override
  Future<void> deleteNotification() async {
    final isSuccess =
        await _notificationsController.deleteNotification(notification.id);

    if (isSuccess) {
      Get.back();
    }
  }
}
