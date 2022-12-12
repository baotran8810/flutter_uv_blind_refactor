import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/theme/styles.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/semantics_manage_controller/semantics_manage_controller.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_inkwell.dart';
import 'package:get/get.dart';

class AppHeader extends AppGetView<AppHeaderController> {
  final String titleText;

  /// If this != null, it will replace the titleText
  final Widget? title;

  final String? semanticsTitle;
  final bool hideBackButton;
  final List<BottomActionInfo> btnInfoList;
  final Widget? bottomChild;
  final String? helpScript;
  final bool hideMenuButton;
  final void Function()? onPressedBack;

  AppHeader({
    Key? key,
    required this.titleText,
    this.title,
    this.semanticsTitle,
    this.hideBackButton = false,
    this.btnInfoList = const [],
    this.helpScript,
    this.bottomChild,
    this.onPressedBack,
    this.hideMenuButton = false,
  }) : super(
          key: key,
          initialController: AppHeaderControllerImpl(
            readingService: Get.find(),
          ),
        );

  final double _kMainActionWidth = 34;
  final double _kMainActionsSpace = 4;
  final double _kMainActionLength = 2;

  @override
  Widget build(BuildContext context, AppHeaderController controller) {
    final double actionsContainerWidth =
        _kMainActionWidth * _kMainActionLength +
            _kMainActionsSpace * (_kMainActionLength - 1);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.paddingNormal,
      ),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                // Left actions
                Container(
                  width: actionsContainerWidth,
                  child: Row(
                    children: [
                      if (!hideBackButton) _buildBackButton(),
                    ],
                  ),
                ),
                // Title
                Expanded(
                  child: title != null
                      ? title!
                      : AppSemantics(
                          semanticId:
                              getSemanticsIdOfPageTitle(Get.currentRoute),
                          labelList: [semanticsTitle ?? titleText],
                          child: AutoSizeText(
                            titleText,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            minFontSize: 8,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.headerText,
                          ),
                        ),
                ),
                // Right actions
                Container(
                  width: actionsContainerWidth,
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (helpScript != null)
                        _buildHelpActionButton(
                          onPressed: () {
                            controller.speak(helpScript!);

                            // Use this to debug (view) sqlite database
                            // final sqliteDb = Get.find<DatabaseSqlite>();
                            // Get.to(MoorDbViewer(sqliteDb));
                          },
                        ),
                      SizedBox(width: _kMainActionsSpace),
                      if (!hideMenuButton) _buildMenuButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (btnInfoList.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 10),
              child: BottomActions(
                actionInfoList: btnInfoList,
              ),
            ),
          if (bottomChild != null) ...{
            Container(
              margin: EdgeInsets.only(top: 10),
              child: bottomChild,
            ),
          }
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return _buildMainActionBtn(
      semanticText: tra(LocaleKeys.semBtn_back),
      onPressed: () {
        if (onPressedBack != null) {
          onPressedBack!.call();
        } else {
          Get.back();
        }
      },
      color: AppColors.burgundyRed,
      iconImgAsset: AppAssets.iconBack,
    );
  }

  Widget _buildMenuButton() {
    return _buildMainActionBtn(
      semanticText: tra(LocaleKeys.semBtn_goToMenu),
      onPressed: () {
        Get.toNamed(AppRoutes.menu);
      },
      color: AppColors.burgundyRed,
      iconImgAsset: AppAssets.iconList,
    );
  }

  Widget _buildHelpActionButton({
    required void Function() onPressed,
  }) {
    return _buildMainActionBtn(
      semanticText: tra(LocaleKeys.semBtn_help),
      onPressed: onPressed,
      color: AppColors.lightGreen,
      iconImgAsset: AppAssets.iconHelp,
    );
  }

  Widget _buildMainActionBtn({
    required String semanticText,
    required void Function() onPressed,
    required Color color,
    required String iconImgAsset,
  }) {
    return AppSemantics(
      labelList: [semanticText],
      isButton: true,
      child: AppInkwell(
        onPressed: onPressed,
        width: _kMainActionWidth,
        height: _kMainActionWidth,
        borderRadius: BorderRadius.circular(4),
        decoration: BoxDecoration(
          color: color,
        ),
        child: Center(
          child: Image.asset(
            iconImgAsset,
            height: 20,
          ),
        ),
      ),
    );
  }
}

class BottomActionInfo {
  final String semanticText;
  final Color color;
  final String iconImgAsset;
  final void Function() onPressed;
  final bool hasNewBadge;
  final double imageSize;

  BottomActionInfo({
    required this.semanticText,
    required this.color,
    required this.iconImgAsset,
    required this.onPressed,
    this.imageSize = 24,
    this.hasNewBadge = false,
  });
}

class BottomActions extends StatelessWidget {
  final List<BottomActionInfo> actionInfoList;

  const BottomActions({
    Key? key,
    required this.actionInfoList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...actionInfoList
            .map((actionInfo) => _buildActionBtn(actionInfo))
            .toList(),
      ],
    );
  }

  Widget _buildActionBtn(BottomActionInfo info) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AppSemantics(
            labelList: [info.semanticText],
            isButton: true,
            child: AppInkwell(
              onPressed: info.onPressed,
              width: 40,
              height: 40,
              borderRadius: BorderRadius.circular(4),
              decoration: BoxDecoration(
                color: info.color,
              ),
              child: Center(
                child: Image.asset(
                  info.iconImgAsset,
                  height: info.imageSize,
                ),
              ),
            ),
          ),
          if (info.hasNewBadge)
            Positioned(
              top: -5,
              right: -5,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10000),
                  color: Colors.red,
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
