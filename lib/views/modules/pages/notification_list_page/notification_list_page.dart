import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/datetime_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notification_app_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notification_dto.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/notifications_controller/notifications_controller.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/notification_list_page/notification_list_page_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/notification_list_page/notification_list_page_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_listview/app_listview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_loading.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_network_image.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_shimmer.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

part 'widgets/notification_item.dart';
part 'widgets/shimmer_notifications.dart';

class NotificationListPage extends AppGetView<NotificationListPageController> {
  final NotificationsController notificationsController;

  NotificationListPage({
    Key? key,
    required this.notificationsController,
  }) : super(
          key: key,
          initialController: NotificationListPageControllerImpl(),
        );

  @override
  Widget build(
    BuildContext context,
    NotificationListPageController controller,
  ) {
    return BaseLayout(
      hasSafeAreaBody: false,
      header: AppHeader(
        titleText: tra(LocaleKeys.titlePage_notificationList),
        semanticsTitle: tra(LocaleKeys.semTitlePage_notificationList),
        btnInfoList: [
          BottomActionInfo(
            semanticText: tra(LocaleKeys.semBtn_readAllNotif),
            color: Color(0xFF00689D),
            iconImgAsset: AppAssets.iconCheck,
            onPressed: () {
              notificationsController.markAllAsReadNotifications();
            },
          ),
          BottomActionInfo(
            semanticText: tra(LocaleKeys.semBtn_deleteAllNotif),
            color: Color(0xFFE5243B),
            iconImgAsset: AppAssets.iconTrash,
            onPressed: () {
              notificationsController.deleteAllNotifications();
            },
          ),
        ],
        helpScript: tra(LocaleKeys.helpScript_notificationList),
      ),
      body: Obx(
        () {
          final bool isLoading = notificationsController.isLoading;
          final List<NotificationAppDto> notificationList =
              notificationsController.notificationList;

          if (notificationsController.isLoading &&
              notificationsController.notificationList.isEmpty) {
            return _ShimmerListView();
          }

          return LazyLoadScrollView(
            onEndOfPage: () {
              notificationsController.loadMore();
            },
            isLoading: isLoading,
            child: AppListView(
              itemCount: isLoading == false
                  ? notificationList.length
                  : notificationList.length + 1,
              itemBuilder: (context, index) {
                if (index >= notificationList.length) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      vertical: AppDimens.paddingNormal,
                    ),
                    child: AppLoading(),
                  );
                }

                final NotificationAppDto notification = notificationList[index];

                return _NotificationItem(
                  notification: notification,
                  onPressedItem: () {
                    notificationsController
                        .goToNotificationDetail(notification.id);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
