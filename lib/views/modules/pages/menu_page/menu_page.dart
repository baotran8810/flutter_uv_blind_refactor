import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/app_info_controller/app_info_controller.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/notifications_controller/notifications_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_inkwell.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuPage extends StatelessWidget {
  final AppInfoController appInfoController;
  final NotificationsController notificationsController;

  const MenuPage({
    Key? key,
    required this.appInfoController,
    required this.notificationsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      header: AppHeader(
        titleText: tra(LocaleKeys.titlePage_menu),
        semanticsTitle: tra(LocaleKeys.semTitlePage_menu),
        helpScript: tra(LocaleKeys.helpScript_menu),
        hideMenuButton: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              width: 350,
              child: GridView.count(
                childAspectRatio: 3 / 4,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                crossAxisCount: 3,
                children: [
                  _buildItemBtn(
                    name: tra(LocaleKeys.txt_scan),
                    icon: AppSvgAssets.iconMenuScan,
                    semanticText: tra(LocaleKeys.semBtn_goToScan),
                    onClick: () {
                      Get.toNamed(AppRoutes.scan);
                    },
                    color: AppColors.burgundyRed,
                  ),
                  _buildItemBtn(
                    name: tra(LocaleKeys.txt_flie),
                    icon: AppSvgAssets.iconMenuFile,
                    semanticText: tra(LocaleKeys.semBtn_goToFileList),
                    onClick: () {
                      Get.toNamed(AppRoutes.fileList);
                    },
                    color: AppColors.royalBlue,
                  ),
                  Obx(
                    () {
                      final hasAnyUnreadNotifications =
                          notificationsController.hasAnyUnread;

                      return _buildItemBtn(
                        name: tra(LocaleKeys.txt_notifications),
                        icon: AppSvgAssets.iconMenuNoti,
                        semanticText: tra(LocaleKeys.semBtn_goToNotifications),
                        onClick: () {
                          Get.toNamed(AppRoutes.notifications);
                        },
                        color: AppColors.orange,
                        hasNewBadge: hasAnyUnreadNotifications,
                      );
                    },
                  ),
                  _buildItemBtn(
                    name: tra(LocaleKeys.txt_searchByVoice),
                    icon: AppSvgAssets.iconMenuDictation,
                    semanticText: tra(LocaleKeys.semBtn_goToVoiceInput),
                    onClick: () {
                      Get.toNamed(AppRoutes.voiceInput);
                    },
                    color: AppColors.darkMustard,
                  ),
                  _buildItemBtn(
                    name: tra(LocaleKeys.txt_setting),
                    icon: AppSvgAssets.iconMenuSettings,
                    semanticText: tra(LocaleKeys.semBtn_goToSetting),
                    onClick: () {
                      Get.toNamed(AppRoutes.setting);
                    },
                    color: AppColors.darkGreen,
                  ),
                  _buildItemBtn(
                    name: tra(LocaleKeys.txt_language),
                    icon: AppSvgAssets.iconMenuLanguage,
                    semanticText: tra(LocaleKeys.semBtn_goToLangSetting),
                    onClick: () {
                      Get.toNamed(AppRoutes.languageSetting);
                    },
                    color: AppColors.darkGreen,
                  ),
                  _buildItemBtn(
                    name: tra(LocaleKeys.txt_howToUseImage),
                    icon: AppSvgAssets.iconMenuTutorial,
                    semanticText: tra(LocaleKeys.semBtn_goToTutorialPhoto),
                    onClick: () {
                      Get.toNamed(AppRoutes.tutorialImages);
                    },
                    color: AppColors.blue02,
                  ),
                  _buildItemBtn(
                    name: tra(LocaleKeys.txt_howToUseText),
                    icon: AppSvgAssets.iconMenuTutorialText,
                    semanticText: tra(LocaleKeys.semBtn_goToTutorialText),
                    onClick: () {
                      Get.toNamed(AppRoutes.tutorialText);
                    },
                    color: AppColors.blue02,
                  ),
                  _buildItemBtn(
                    name: tra(LocaleKeys.txt_privacyPolicy),
                    icon: AppSvgAssets.iconMenuPrivacy,
                    semanticText: tra(LocaleKeys.semBtn_goToPrivacy),
                    onClick: () async {
                      const String url = 'http://uni-voice.co.jp/policy';
                      if (await canLaunch(url)) {
                        launch(url);
                      }
                    },
                    color: AppColors.magenta,
                  ),
                  _buildItemBtn(
                    name: tra(LocaleKeys.txt_termOfServices),
                    icon: AppSvgAssets.iconMenuPlaceholder,
                    semanticText: tra(LocaleKeys.semBtn_goToTermOfService),
                    onClick: () async {
                      const String url = 'http://uni-voice.co.jp/policies';
                      if (await canLaunch(url)) {
                        launch(url);
                      }
                    },
                    color: AppColors.magenta,
                  ),
                  _buildItemBtn(
                    name: "Uni-voice",
                    icon: AppSvgAssets.iconMenuUV,
                    semanticText: tra(LocaleKeys.semBtn_goToUVWebsite),
                    onClick: () async {
                      const String url = 'http://uni-voice.co.jp';
                      if (await canLaunch(url)) {
                        launch(url);
                      }
                    },
                    color: Colors.white,
                    iconColor: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, AppDimens.paddingSmall, 0),
          alignment: Alignment.bottomRight,
          child: Obx(() {
            final versionName = appInfoController.versionName;
            if (versionName == null) {
              return SizedBox();
            }
            return AppSemantics(
              labelList: [
                tra(
                  LocaleKeys.semTxt_appVersionWA,
                  namedArgs: {'versionName': versionName},
                ),
              ],
              child: Text(
                tra(
                  LocaleKeys.txt_versionWA,
                  namedArgs: {'versionName': versionName},
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildItemBtn({
    required String name,
    required String icon,
    required String semanticText,
    required Function() onClick,
    required Color color,
    bool hasNewBadge = false,
    Color iconColor = Colors.white,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.paddingNormal / 2,
      ),
      child: Column(
        children: [
          ExcludeSemantics(
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 40,
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(height: 2),
          Stack(
            clipBehavior: Clip.none,
            children: [
              AppSemantics(
                labelList: [semanticText],
                isButton: true,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: AppInkwell(
                    borderRadius: BorderRadius.circular(8.0),
                    onPressed: onClick,
                    decoration: BoxDecoration(color: color),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        icon,
                        color: iconColor,
                      ),
                    ),
                  ),
                ),
              ),
              if (hasNewBadge)
                Positioned(
                  top: -12,
                  right: -12,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10000),
                      color: Colors.red,
                      border: Border.all(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
