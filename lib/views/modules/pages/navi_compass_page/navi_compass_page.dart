import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/location_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/dialog_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_dto.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/navi_compass_page/navi_compass_page_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/navi_compass_page/navi_compass_page_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_button_new.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_loading.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:get/get.dart';

part 'widgets/navi_compass.dart';

class NaviCompassPageArguments {
  final String courseName;
  final List<PointDto> pointList;

  const NaviCompassPageArguments({
    required this.courseName,
    required this.pointList,
  });
}

class NaviCompassPage extends AppGetView<NaviCompassPageController> {
  final NaviCompassPageArguments arguments;

  NaviCompassPage({
    Key? key,
    required this.arguments,
  }) : super(
          key: key,
          initialController: NaviCompassPageControllerImpl(
            courseName: arguments.courseName,
            pointList: arguments.pointList,
            speakingService: Get.find(),
            appSettingRepository: Get.find(),
            hardwareService: Get.find(),
          ),
        );

  Future<bool> confirmBack() async {
    final isConfirmed = await DialogViewUtils.showConfirmDialog(
      messageText: tra(
        LocaleKeys.txt_endNaviGuidanceConfirm,
      ),
    );

    return isConfirmed;
  }

  @override
  Widget build(BuildContext context, NaviCompassPageController controller) {
    final bool isShowFindNearestBtn = arguments.pointList.length > 1;

    return WillPopScope(
      onWillPop: () async {
        return confirmBack();
      },
      child: BaseLayout(
        header: AppHeader(
          titleText: tra(LocaleKeys.titlePage_naviCompass),
          semanticsTitle: tra(LocaleKeys.semTitlePage_naviCompass),
          helpScript: tra(LocaleKeys.helpScript_naviCompass),
          onPressedBack: () async {
            final bool isConfirmed = await confirmBack();
            if (isConfirmed) {
              Get.back();
            }
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 24),
            Obx(
              () {
                final accuracy = controller.currentAccuracy;

                final displayAccuracy = accuracy == null
                    ? ''
                    : tra(
                        LocaleKeys.txt_displayAccuracyWA,
                        namedArgs: {
                          "accuracy": accuracy.toStringAsFixed(0),
                        },
                      );

                return AppSemantics(
                  labelList: [displayAccuracy],
                  child: Text(
                    displayAccuracy,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 32),
            Obx(
              () {
                return _Compass(
                  locationStatus: controller.locationStatus,
                  isLoading: controller.isLoadingAngle ||
                      controller.locationStatus == AppLocationStatus.loading,
                  headingPoint: controller.headingPoint,
                  currentCoordinate: controller.currentCoordinate,
                  angleDegree: controller.angleDegree,
                );
              },
            ),
            SizedBox(height: 32),
            Column(
              children: [
                Container(
                  width: 230,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isShowFindNearestBtn)
                        Container(
                          margin: EdgeInsets.only(
                            bottom: AppDimens.paddingNormal,
                          ),
                          child: _ActionButton(
                            onPressed: () {
                              controller.refreshHeadingPoint();
                            },
                            color: Color(0xFF4C9F38),
                            semText:
                                tra(LocaleKeys.semBtn_startFromNearestPoint),
                            text: tra(LocaleKeys.btn_startFromNearestPoint),
                          ),
                        ),
                      _ActionButton(
                        onPressed: () {
                          controller.openMap();
                        },
                        color: Color(0xFFA21942),
                        semText: tra(LocaleKeys.btn_openMap),
                        text: tra(LocaleKeys.btn_openMap),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final Color color;
  final String semText;
  final String text;
  final void Function() onPressed;

  const _ActionButton({
    Key? key,
    required this.color,
    required this.semText,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButtonNew(
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
    );
  }
}
