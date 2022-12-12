import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/responsive_view_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/string_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/navi_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/navi_menu_page/navi_menu_page_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/navi_menu_page/navi_menu_page_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_button_new.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:get/get.dart';

class NaviMenuPageArguments {
  final NaviScanCodeDto naviScanCode;

  NaviMenuPageArguments({
    required this.naviScanCode,
  });
}

class NaviMenuPage extends AppGetView<NaviMenuPageController> {
  final NaviMenuPageArguments arguments;

  NaviMenuPage({
    Key? key,
    required this.arguments,
  }) : super(
          key: key,
          initialController: NaviMenuPageControllerImpl(
            analyticsService: Get.find(),
            scanCodeRepository: Get.find(),
            naviCode: arguments.naviScanCode,
          ),
        );

  @override
  Widget build(BuildContext context, NaviMenuPageController controller) {
    final bool isTablet = ResponsiveViewUtils.isTablet();

    return BaseLayout(
      header: Obx(() {
        final isBookmark = controller.isBookmark;
        return AppHeader(
          titleText: tra(LocaleKeys.titlePage_naviMenu),
          semanticsTitle: tra(LocaleKeys.semTitlePage_naviMenu),
          helpScript: tra(LocaleKeys.helpScript_naviMenu),
          bottomChild: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BottomActions(
                actionInfoList: [
                  BottomActionInfo(
                    semanticText: !isBookmark
                        ? tra(LocaleKeys.semBtn_fileBookmark)
                        : tra(LocaleKeys.semBtn_fileUnbookmark),
                    color: Color(0xFFFD9D24),
                    iconImgAsset:
                        !isBookmark ? AppAssets.iconStar : AppAssets.iconUnStar,
                    onPressed: () {
                      controller.setBookmark();
                    },
                  ),
                  BottomActionInfo(
                    imageSize: 40,
                    color: Colors.transparent,
                    semanticText: tra(LocaleKeys.semBtn_fileDelete),
                    onPressed: () {
                      controller.deleteCode();
                    },
                    iconImgAsset: AppAssets.iconDelete,
                  ),
                ],
              )
            ],
          ),
        );
      }),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: isTablet
                    ? EdgeInsets.symmetric(vertical: 36, horizontal: 20)
                    : EdgeInsets.symmetric(vertical: 24),
                child: AppSemantics(
                  labelList: [
                    controller.textController.text,
                    ...StringViewUtils.getScriptsEditable(),
                  ],
                  child: TextField(
                    controller: controller.textController,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              if (isTablet) SizedBox(height: 50),
              Column(
                children: [
                  _NaviPageButton(
                    color: Color(0xFF3F7E44),
                    semText: tra(LocaleKeys.semBtn_startNavi),
                    text: tra(LocaleKeys.btn_startGuidance),
                    onPressed: () {
                      controller.openGuidance();
                    },
                  ),
                  _NaviPageButton(
                    color: Color(0xFFFD6925),
                    semText: tra(LocaleKeys.semBtn_showRoute),
                    text: tra(LocaleKeys.btn_openDirections),
                    onPressed: () {
                      controller.openDirections();
                    },
                  ),
                  _NaviPageButton(
                    color: Color(0xFF00689D),
                    semText: tra(LocaleKeys.semBtn_reverseRoute),
                    text: tra(LocaleKeys.btn_reverseRoute),
                    onPressed: () async {
                      await controller.toggleRevert();
                    },
                  ),
                  _NaviPageButton(
                    color: Color(0xFFA21942),
                    semText: tra(LocaleKeys.semBtn_showMap),
                    text: tra(LocaleKeys.btn_openMap),
                    onPressed: () async {
                      await controller.openMap();
                    },
                  ),
                  _NaviPageButton(
                    color: Color(0xFFBF8B2E),
                    semText: tra(LocaleKeys.semBtn_openSetting),
                    text: tra(LocaleKeys.btn_openSettings),
                    onPressed: () {
                      controller.openSettings();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NaviPageButton extends StatelessWidget {
  final Color color;
  final String semText;
  final String text;
  final void Function() onPressed;

  const _NaviPageButton({
    Key? key,
    required this.color,
    required this.semText,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      width: ResponsiveViewUtils.isTablet() ? 460 : 230,
      child: AppButtonNew(
        onPressed: () {
          onPressed();
        },
        height: 56,
        btnColor: color,
        textColor: Colors.white,
        borderRadius: BorderRadius.circular(4),
        semanticLabel: semText,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
