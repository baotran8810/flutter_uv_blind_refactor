import 'package:flutter/cupertino.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/location_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/log_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/permission_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/dialog_view_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/loading_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/navi_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/scan_code_repository/scan_code_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/analytics_service/analytics_service.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_life_cycle/app_life_cycle_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/navi_compass_page/navi_compass_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/navi_direction_page/navi_direction_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/navi_menu_page/navi_menu_page_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class NaviMenuPageControllerImpl extends AppLifeCycleController
    implements NaviMenuPageController {
  final AnalyticsService _analyticsService;
  final ScanCodeRepository _scanCodeRepository;

  // Arguments
  final NaviScanCodeDto naviCode;

  NaviMenuPageControllerImpl({
    required AnalyticsService analyticsService,
    required ScanCodeRepository scanCodeRepository,
    required this.naviCode,
  })  : _analyticsService = analyticsService,
        _scanCodeRepository = scanCodeRepository;

  final Rx<bool> _isBookmark = false.obs;

  final TextEditingController _textController = TextEditingController();
  @override
  TextEditingController get textController => _textController;

  @override
  Future<void> onInit() async {
    super.onInit();
    _isBookmark.value = naviCode.isBookmark;
    _textController.text = naviCode.name;
    _textController.addListener(() {
      _scanCodeRepository.updateName(naviCode.id, _textController.text);
    });
    await PermissionUtils.checkLocation();
  }

  @override
  Future<void> onAppResume() async {
    super.onAppResume();

    if (await Permission.location.isPermanentlyDenied) {
      Get.back();
    }
  }

  @override
  void onClose() {
    _textController.dispose();
    super.onClose();
  }

  @override
  Future<void> openGuidance() async {
    // Analytics
    _analyticsService.logNaviActionFromNavi(
      action: NaviAction.start,
      codeName: naviCode.name,
      codeInfo: naviCode.codeInfo,
    );

    await Get.toNamed(
      AppRoutes.naviCompass,
      arguments: NaviCompassPageArguments(
        courseName: naviCode.name,
        pointList: naviCode.pointList,
      ),
    );

    // Analytics
    _analyticsService.logNaviActionFromNavi(
      action: NaviAction.stop,
      codeName: naviCode.name,
      codeInfo: naviCode.codeInfo,
    );
  }

  @override
  void openDirections() {
    Get.toNamed(
      AppRoutes.naviDirection,
      arguments: NaviDirectionPageArguments(
        naviCode: naviCode,
        onToggleRevert: () {
          naviCode.revertPointList();
        },
      ),
    );
  }

  @override
  Future<void> toggleRevert() async {
    final isConfirmed = await DialogViewUtils.showConfirmDialog(
      messageText: tra(LocaleKeys.txt_revertNaviConfirm),
    );

    if (!isConfirmed) {
      return;
    }

    naviCode.revertPointList();
  }

  @override
  Future<void> openMap() async {
    await LoadingViewUtils.showLoading();
    Position? position;
    try {
      position = await LocationUtils.getCurrentPosition();
    } catch (e, st) {
      LogUtils.e('Cannot get position', e, st);
      // TODO show dialog
    }
    await LoadingViewUtils.hideLoading();

    if (position == null) {
      return;
    }

    MapsLauncher.launchCoordinates(position.latitude, position.longitude);
  }

  @override
  void openSettings() {
    Get.toNamed(AppRoutes.setting);
  }

  @override
  Future<void> deleteCode() async {
    final isConfirmed = await DialogViewUtils.showConfirmDialog(
      titleText: tra(LocaleKeys.txt_delete),
      messageText: tra(LocaleKeys.txt_deleteFileConfirm),
    );

    if (!isConfirmed) {
      return;
    }

    await _scanCodeRepository.deleteScanCode(naviCode.id);
    Get.back();
  }

  @override
  bool get isBookmark => _isBookmark.value;

  @override
  Future<void> setBookmark() async {
    await _scanCodeRepository.updateIsBookmark(naviCode.id);
    _isBookmark.value = !_isBookmark.value;
  }
}
