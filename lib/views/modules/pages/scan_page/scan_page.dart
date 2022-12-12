import 'package:flutter/material.dart';
import 'package:flutter_camera_uv_decoder/flutter_camera_uv_decoder.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/notifications_controller/notifications_controller.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/scan_page/scan_page_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/scan_page/scan_page_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/scan_page/widgets/bounding_box_painter.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:get/get.dart';

class ScanPage extends AppGetView<ScanPageController> {
  final NotificationsController notificationsController;

  ScanPage({
    Key? key,
    required this.notificationsController,
  }) : super(
          key: key,
          initialController: ScanPageControllerImpl(
            analyticsService: Get.find(),
            appSettingRepository: Get.find(),
            scanCodeRepository: Get.find(),
            scanDecodeService: Get.find(),
            signLanguageService: Get.find(),
            speakingService: Get.find(),
            hardwareService: Get.find(),
          ),
          doRegisterRouteAware: true,
        );

  @override
  void onPushNext(ScanPageController controller) {
    controller.onPushNext();
  }

  @override
  void onPopNext(ScanPageController controller) {
    controller.onPopNext();
  }

  @override
  Widget build(BuildContext context, ScanPageController controller) {
    return BaseLayout(
      header: Obx(
        () {
          final hasUnreadNotifications = notificationsController.hasAnyUnread;

          return AppHeader(
            hideBackButton: true,
            titleText: tra(LocaleKeys.titlePage_scanPage),
            semanticsTitle: tra(LocaleKeys.semTitlePage_scanPageNoNewBagde),
            helpScript: tra(LocaleKeys.helpScript_scan),
            btnInfoList: [
              BottomActionInfo(
                semanticText: tra(LocaleKeys.semBtn_goToFileList),
                onPressed: () {
                  Get.toNamed(AppRoutes.fileList);
                },
                iconImgAsset: AppAssets.iconMenuFile,
                color: AppColors.royalBlue,
              ),
              BottomActionInfo(
                semanticText: tra(LocaleKeys.semBtn_goToNotifications),
                onPressed: () {
                  Get.toNamed(AppRoutes.notifications);
                },
                iconImgAsset: AppAssets.iconMenuNoti,
                color: AppColors.orange,
                hasNewBadge: hasUnreadNotifications,
              ),
              BottomActionInfo(
                semanticText: tra(LocaleKeys.semBtn_goToVoiceInput),
                onPressed: () {
                  Get.toNamed(AppRoutes.voiceInput);
                },
                iconImgAsset: AppAssets.iconMenuDictation,
                color: AppColors.darkMustard,
              ),
              BottomActionInfo(
                semanticText: tra(LocaleKeys.semBtn_goToColorSetting),
                onPressed: () {
                  Get.toNamed(AppRoutes.settingScan);
                },
                iconImgAsset: AppAssets.iconEdit,
                color: AppColors.blue02,
              ),
            ],
          );
        },
      ),
      hasSafeAreaBody: false,
      body: _buildBody(context, controller),
    );
  }
}

Widget _buildBody(BuildContext context, ScanPageController controller) {
  return ExcludeSemantics(
    child: Obx(
      () {
        final bool cameraIsWork = controller.cameraIsWork;

        return cameraIsWork
            ? SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: CameraPreview(
                  controller.cameraController,
                  child: Stack(
                    children: [
                      Container(
                        child: Obx(
                          () {
                            final Size? cameraPreviewSize =
                                controller.cameraController.value.previewSize;
                            final UVRect? points = controller.points;
                            final int borderLevel = controller.borderLevel;
                            final int borderColor = controller.borderColor;

                            if (cameraPreviewSize == null) {
                              return SizedBox();
                            }

                            return CustomPaint(
                              painter: BoundingBoxPainter(
                                cameraPreviewSize: cameraPreviewSize,
                                boundingBox: points,
                                color: borderColor,
                                stroke: borderLevel,
                              ),
                              child: Container(
                                color: const Color(0x1A000000),
                              ),
                            );
                          },
                        ),
                      ),
                      Obx(
                        () {
                          final int brightness = controller.brightness;

                          return _iconBrightness(brightness);
                        },
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    ),
  );
}

Widget _iconBrightness(int brightness) {
  if (brightness == -1) {
    return Column(
      children: [
        Center(
          child: Image.asset(
            AppAssets.iconLackOfBrightness,
            width: 80,
            height: 80,
          ),
        )
      ],
    );
  }
  if (brightness == 1) {
    return Column(
      children: [
        Center(
          child: Image.asset(
            AppAssets.iconOutOfBrightness,
            width: 80,
            height: 80,
          ),
        )
      ],
    );
  }
  return Container();
}
