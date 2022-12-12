import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/notification/notification_app_dto.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/notification_detail_page/notification_detail_page_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/notification_detail_page/notification_detail_page_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_button_new.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_loading.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_network_image.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

part 'widgets/notification_actions.dart';
part 'widgets/notification_content.dart';

class NotificationDetailPageArguments {
  final NotificationAppDto notification;
  final void Function()? onDeleted;
  final void Function()? onToggledLike;

  NotificationDetailPageArguments({
    required this.notification,
    this.onDeleted,
    this.onToggledLike,
  });
}

class NotificationDetailPage
    extends AppGetView<NotificationDetailPageController> {
  final NotificationDetailPageArguments arguments;

  NotificationDetailPage({
    Key? key,
    required this.arguments,
  }) : super(
          key: key,
          initialController: NotificationDetailPageControllerImpl(
            analyticsService: Get.find(),
            notificationRepository: Get.find(),
            notificationService: Get.find(),
            scanDecodeService: Get.find(),
            scanCodeRepository: Get.find(),
            notificationsController: Get.find(),
            notification: arguments.notification,
            onToggledLike: arguments.onToggledLike,
          ),
        );

  @override
  Widget build(
    BuildContext context,
    NotificationDetailPageController controller,
  ) {
    return BaseLayout(
      header: AppHeader(
        titleText: tra(LocaleKeys.titlePage_notificationDetail),
        semanticsTitle: tra(LocaleKeys.semTitlePage_notificationDetail),
        btnInfoList: [
          BottomActionInfo(
            semanticText: tra(LocaleKeys.semBtn_deleteNotifItem),
            color: Color(0xFFFD6925),
            iconImgAsset: AppAssets.iconTrash,
            onPressed: () {
              controller.deleteNotification();
            },
          ),
        ],
        helpScript: tra(LocaleKeys.helpScript_notificationDetail),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _NotificationContent(
              notification: arguments.notification,
              containerWidth: Get.width,
            ),
          ),
          Obx(() {
            final bool hasLiked = controller.currentHasLiked;
            final bool isLoadingLikedCount = controller.isLoadingLikedCount;
            final int currentLikedCount = controller.currentLikedCount;

            return _NotificationActions(
              notification: arguments.notification,
              hasLiked: hasLiked,
              isLoadingLikedCount: isLoadingLikedCount,
              currentLikedCount: currentLikedCount,
              onPressedDecodeScaoCode: () async {
                await controller.decodeScanCode();
              },
              onPressedLike: () async {
                if (isLoadingLikedCount) {
                  return;
                }

                await controller.toggleLikeNotification();
              },
              onPressedShare: () async {
                await controller.shareNotification();
              },
            );
          }),
        ],
      ),
    );
  }
}
