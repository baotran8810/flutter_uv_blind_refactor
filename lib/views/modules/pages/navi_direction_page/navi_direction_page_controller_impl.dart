import 'dart:async';

import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/location_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/dialog_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/navi_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/analytics_service/analytics_service.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/navi_compass_page/navi_compass_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/navi_direction_page/navi_direction_page_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class NaviDirectionPageControllerImpl extends GetxController
    implements NaviDirectionPageController {
  final AnalyticsService _analyticsService;

  final NaviScanCodeDto naviCode;

  NaviDirectionPageControllerImpl({
    required AnalyticsService analyticsService,
    required this.naviCode,
  }) : _analyticsService = analyticsService;

  final Rx<List<PointDto>> _pointList = Rx([]);
  @override
  List<PointDto> get pointList => _pointList.value;

  final Rx<AppLocationStatus> _locationStatus = AppLocationStatus.notAsked.obs;
  @override
  AppLocationStatus get locationStatus => _locationStatus.value;

  final Rx<CoordinateDto?> _startCoordinate = Rx(null);
  @override
  CoordinateDto? get startCoordinate => _startCoordinate.value;

  @override
  Future<void> onInit() async {
    super.onInit();

    _pointList.value = naviCode.pointList;
    await _fetchCurrentPosition();
  }

  Future<void> _fetchCurrentPosition() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _locationStatus.value = AppLocationStatus.denied;
      return;
    }

    _locationStatus.value = AppLocationStatus.loading;
    final currentPosition = await LocationUtils.getCurrentPosition();
    _startCoordinate.value = CoordinateDto(
      latitude: currentPosition.latitude,
      longitude: currentPosition.longitude,
    );

    _locationStatus.value = AppLocationStatus.loaded;
  }

  @override
  Future<void> toggleRevert() async {
    final isConfirmed = await DialogViewUtils.showConfirmDialog(
      messageText: tra(LocaleKeys.txt_revertNaviConfirm),
    );

    if (!isConfirmed) {
      return;
    }

    _pointList.value = pointList.reversed.toList();
  }

  @override
  Future<void> choosePoint(String id) async {
    final int pointIndex = pointList.indexWhere((point) => point.id == id);
    final PointDto point = pointList[pointIndex];
    final List<PointDto> pointListToGo = pointList.sublist(pointIndex);

    final isConfirmed = await DialogViewUtils.showConfirmDialog(
      messageText: tra(
        LocaleKeys.txt_startNaviConfirmWA,
        namedArgs: {
          'pointName': point.pointName,
        },
      ),
    );

    if (!isConfirmed) {
      return;
    }

    _analyticsService.logNaviActionFromNavi(
      action: NaviAction.start,
      codeName: naviCode.name,
      codeInfo: naviCode.codeInfo,
    );

    await Get.toNamed(
      AppRoutes.naviCompass,
      arguments: NaviCompassPageArguments(
        courseName: naviCode.name,
        pointList: pointListToGo,
      ),
    );

    _analyticsService.logNaviActionFromNavi(
      action: NaviAction.stop,
      codeName: naviCode.name,
      codeInfo: naviCode.codeInfo,
    );
  }
}
