import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/log_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/dialog_view_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/loading_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notification_app_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/notification_repository/notification_repository.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/notifications_controller/notifications_controller.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_life_cycle/app_life_cycle_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/notification_detail_page/notification_detail_page.dart';
import 'package:get/get.dart';

const int _limitPerRequest = 20;

class NotificationsControllerImpl extends AppLifeCycleController
    implements NotificationsController {
  final NotificationRepository _notificationRepository;

  NotificationsControllerImpl({
    required NotificationRepository notificationRepository,
  }) : _notificationRepository = notificationRepository;

  final Rx<bool> _isLoading = Rx(false);
  @override
  bool get isLoading => _isLoading.value;

  final Rx<List<NotificationAppDto>> _notificationList = Rx([]);
  @override
  List<NotificationAppDto> get notificationList => _notificationList.value;

  @override
  bool get hasAnyUnread =>
      notificationList.any((notification) => notification.hasRead == false);

  // Pagination stuff
  int _currentSkip = 0;
  bool _hasMore = true;

  @override
  void onAppResume() {
    // ! This is because onesignal 3.2.0 can't handle push notif received in background,
    // ! so we have to workaround like this
    refreshNotificationList();
  }

  Future<void> _fetchNotifications({bool isLoadMore = false}) async {
    if (isLoadMore == false) {
      // Refresh pagination
      _notificationList.value.clear();
      _currentSkip = 0;
      _hasMore = true;
    }

    _isLoading.value = true;

    final data = await _notificationRepository.getNotificationList(
      skip: _currentSkip,
      limit: _limitPerRequest,
    );

    if (data != null) {
      _notificationList.value.addAll(data);

      _currentSkip += _limitPerRequest;
      _hasMore = data.length == _limitPerRequest;
    }

    _isLoading.value = false;
    _notificationList.refresh();
  }

  /// Apply hasDeleted filter, hasLiked & hasRead status based on
  /// `notificationsInfo` in local database, to every item in
  /// the [_notificationList] & re-render UI
  Future<void> _applyNotificationsInfo() async {
    final notificationsInfo =
        await _notificationRepository.getNotificationsInfo();

    // Apply hasRead & hasLiked (MUTATE)
    for (final notification in _notificationList.value) {
      notification.applyNotificationsInfo(notificationsInfo);
    }

    // Filter out deleted items
    final deletedIdList = notificationsInfo.notificationIdListDeleted;
    _notificationList.value.removeWhere(
      (notification) => deletedIdList.contains(notification.id),
    );

    // Re-render the list
    _notificationList.refresh();
  }

  @override
  Future<void> refreshNotificationList() async {
    _fetchNotifications();
  }

  @override
  Future<void> loadMore() async {
    if (_hasMore == false || isLoading) {
      return;
    }

    await _fetchNotifications(
      isLoadMore: true,
    );
  }

  @override
  Future<void> goToNotificationDetail(int id) async {
    final foundNotif =
        notificationList.firstWhereOrNull((notif) => notif.id == id);

    if (foundNotif == null) {
      LogUtils.e('Cannot find notification with id: $id');
      return;
    }

    await Get.toNamed(
      AppRoutes.notificationDetail,
      arguments: NotificationDetailPageArguments(notification: foundNotif),
    );

    await _applyNotificationsInfo();
  }

  @override
  Future<void> markAsReadNotification(int id) async {
    await _notificationRepository.readNotification(id);
    await _applyNotificationsInfo();
  }

  @override
  Future<bool> deleteNotification(int id) async {
    final isConfirmed = await DialogViewUtils.showConfirmDialog(
      titleText: tra(LocaleKeys.txt_delete),
      messageText: tra(LocaleKeys.txt_deleteMessageConfirm),
    );

    if (!isConfirmed) {
      return false;
    }

    await LoadingViewUtils.showLoading();
    await _notificationRepository.deleteNotification(id);
    await _applyNotificationsInfo();
    await LoadingViewUtils.hideLoading();
    return true;
  }

  @override
  Future<void> markAllAsReadNotifications() async {
    await LoadingViewUtils.showLoading();
    await _notificationRepository.readAllNotifications();
    await _applyNotificationsInfo();
    await LoadingViewUtils.hideLoading();
  }

  @override
  Future<void> deleteAllNotifications() async {
    final isConfirmed = await DialogViewUtils.showConfirmDialog(
      titleText: tra(LocaleKeys.txt_delete),
      messageText: tra(LocaleKeys.txt_deleteAllMessagesConfirm),
    );

    if (!isConfirmed) {
      return;
    }

    await LoadingViewUtils.showLoading();
    await _notificationRepository.deleteAllNotifications();
    await LoadingViewUtils.hideLoading();

    _fetchNotifications();
  }
}
