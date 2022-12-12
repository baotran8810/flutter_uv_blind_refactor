import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/angle_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/location_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/navi_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_dto.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/navi_direction_page/navi_direction_page_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/navi_direction_page/navi_direction_page_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_button_new.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_loading.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:get/get.dart';

part 'widgets/header_section.dart';
part 'widgets/points_section.dart';

class NaviDirectionPageArguments {
  final NaviScanCodeDto naviCode;
  final void Function()? onToggleRevert;

  NaviDirectionPageArguments({
    required this.naviCode,
    this.onToggleRevert,
  });
}

class NaviDirectionPage extends AppGetView<NaviDirectionPageController> {
  final NaviDirectionPageArguments arguments;

  NaviDirectionPage({
    Key? key,
    required this.arguments,
  }) : super(
          key: key,
          initialController: NaviDirectionPageControllerImpl(
            analyticsService: Get.find(),
            naviCode: arguments.naviCode,
          ),
        );

  @override
  Widget build(BuildContext context, NaviDirectionPageController controller) {
    return BaseLayout(
      header: AppHeader(
        titleText: tra(LocaleKeys.titlePage_naviDirections),
        helpScript: tra(LocaleKeys.helpScript_routeList),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _HeadingSection(
              titleText: arguments.naviCode.name,
              onPressedToggleRevert: () {
                controller.toggleRevert();
                arguments.onToggleRevert?.call();
              },
              onPressedBack: () {
                Get.back();
              },
            ),
            Obx(
              () {
                final AppLocationStatus locationStatus =
                    controller.locationStatus;

                final List<PointDto> pointList = controller.pointList;

                final CoordinateDto? startCoordinate =
                    controller.startCoordinate;

                if (locationStatus == AppLocationStatus.notAsked ||
                    locationStatus == AppLocationStatus.loading) {
                  return Container(
                    margin: EdgeInsets.only(top: 64),
                    child: AppLoading(),
                  );
                }

                if (locationStatus == AppLocationStatus.denied) {
                  return Text('Location permission denied');
                }

                if (startCoordinate == null) {
                  // TODO refactor
                  return Text('Unexpected error: Cannot get location');
                }

                return _PointsSection(
                  locationStatus: locationStatus,
                  pointList: pointList,
                  startCoordinate: startCoordinate,
                  onPressedPoint: (point) {
                    controller.choosePoint(point.id);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
