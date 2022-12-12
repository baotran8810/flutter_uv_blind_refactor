import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/code_info_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_app_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/analytics_service/analytics_service.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/facility_detail_page/facility_point_detail_page_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/navi_compass_page/navi_compass_page.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class FacilityPointDetailPageControllerImpl
    implements FacilityPointDetailPageController {
  final AnalyticsService _analyticsService;

  final PointAppDto point;
  final CodeInfoDto? codeInfo;

  FacilityPointDetailPageControllerImpl({
    required AnalyticsService analyticsService,
    required this.point,
    required this.codeInfo,
  }) : _analyticsService = analyticsService;

  @override
  Future<void> openNaviCompass() async {
    // Analytics
    _analyticsService.logNaviActionFromSpot(
      action: NaviAction.start,
      pointName: point.pointName,
      codeInfo: codeInfo,
    );

    await Get.toNamed(
      AppRoutes.naviCompass,
      arguments: NaviCompassPageArguments(
        courseName: point.pointName,
        pointList: [point],
      ),
    );

    // Analytics
    _analyticsService.logNaviActionFromSpot(
      action: NaviAction.stop,
      pointName: point.pointName,
      codeInfo: codeInfo,
    );
  }

  @override
  void openMap() {
    MapsLauncher.launchCoordinates(
      point.coordinate.latitude,
      point.coordinate.longitude,
    );
  }

  @override
  void openSearch() {
    launch(
      Uri.encodeFull('https://www.google.com/search?q=${point.pointName}'),
    );
  }
}
