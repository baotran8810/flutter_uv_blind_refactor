import 'dart:async';

import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/permission_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/dialog_view_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/loading_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/facility_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_app_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/scan_code_repository/scan_code_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/location_service/location_service.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_life_cycle/app_life_cycle_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/facility_detail_page/facility_point_detail_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/facility_main_page/facility_main_page_controller.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class FacilityMainPageControllerImpl extends AppLifeCycleController
    implements FacilityMainPageController {
  final LocationService _locationService;
  final ScanCodeRepository _scanCodeRepository;
  final FacilityScanCodeDto facilityScanCode;

  FacilityMainPageControllerImpl({
    required LocationService locationService,
    required this.facilityScanCode,
    required ScanCodeRepository scanCodeRepository,
  })  : _locationService = locationService,
        _scanCodeRepository = scanCodeRepository;

  List<PointAppDto> _originalPointList = [];

  final Rx<List<PointAppDto>> _pointList = Rx([]);
  @override
  List<PointAppDto> get pointList => _pointList.value;

  final Rx<bool> _isLoading = Rx(false);
  @override
  bool get isLoading => _isLoading.value;

  final Rx<PointsSortCriteria?> _sortCriteria = Rx(null);
  @override
  PointsSortCriteria? get sortCriteria => _sortCriteria.value;

  final Rx<bool> _isBookmark = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    _isBookmark.value = facilityScanCode.isBookmark;
    await PermissionUtils.checkLocation();
    _initPointList();
  }

  @override
  Future<void> onAppResume() async {
    super.onAppResume();

    if (await Permission.location.isPermanentlyDenied) {
      Get.back();
    } else {
      await _initPointList();
    }
  }

  Future<void> _initPointList() async {
    _isLoading.value = true;

    _originalPointList = facilityScanCode.pointList
        .map((point) => PointAppDto.fromRawDto(point))
        .toList();

    _pointList.value = List.from(_originalPointList);
    await _applyPointsLocationInfo();

    _isLoading.value = false;
    _pointList.refresh();
  }

  Future<void> _applyPointsLocationInfo() async {
    late final CoordinateDto curCoordinate;
    late final double curHeadingDegree;

    await Future.wait([
      () async {
        curCoordinate = await _locationService.getCurrentCoordinate();
      }(),
      () async {
        curHeadingDegree = await _locationService.getHeadingDegree();
      }(),
    ]);

    for (final point in _pointList.value) {
      // ! Mutate
      point.applyDistanceAndAngle(
        currentCoordinate: curCoordinate,
        headingDegree: curHeadingDegree,
      );
    }
  }

  @override
  Future<void> toggleSortBy(PointsSortCriteria criteria) async {
    // * 1: Apply criteria
    if (criteria != sortCriteria) {
      _sortCriteria.value = criteria;
    } else {
      _sortCriteria.value = null;
    }

    // * 2: Apply new distance if sort by distance
    if (sortCriteria == PointsSortCriteria.distance) {
      await LoadingViewUtils.showLoading();
      await _applyPointsLocationInfo();
      await LoadingViewUtils.hideLoading();
    }

    // * 3: Sort
    if (sortCriteria == null) {
      _pointList.value = List.from(_originalPointList);
    } else {
      _pointList.value.sort(
        (point1, point2) {
          switch (sortCriteria!) {
            case PointsSortCriteria.category:
              // Category sort
              return _compareByCategory(point1, point2);
            case PointsSortCriteria.distance:
              // Distance sort
              return _compareByDistance(point1, point2);
          }
        },
      );
      _pointList.refresh();
    }
  }

  int _compareByCategory(PointDto point1, PointDto point2) {
    if (point1.categoryList.isEmpty && point2.categoryList.isNotEmpty) {
      return -1;
    }

    if (point1.categoryList.isNotEmpty && point2.categoryList.isEmpty) {
      return 1;
    }

    if (point1.categoryList.isEmpty && point2.categoryList.isEmpty) {
      return point1.pointName[0].compareTo(point2.pointName[0]);
    }

    return point1.categoryList[0].categoryId -
        point2.categoryList[0].categoryId;
  }

  int _compareByDistance(PointAppDto point1, PointAppDto point2) {
    if (point1.distanceToCurLocation == null ||
        point2.distanceToCurLocation == null) {
      return 1; // TODO handle
    }

    return (point1.distanceToCurLocation! - point2.distanceToCurLocation!)
        .toInt();
  }

  @override
  void goToPointDetail(PointAppDto point) {
    Get.toNamed(
      AppRoutes.facilityPointDetail,
      arguments: FacilityPointDetailPageArguments(
        point: point,
        codeInfo: facilityScanCode.codeInfo,
      ),
    );
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

    await _scanCodeRepository.deleteScanCode(facilityScanCode.id);
    Get.back();
  }

  @override
  bool get isBookmark => _isBookmark.value;

  @override
  Future<void> setBookmark() async {
    await _scanCodeRepository.updateIsBookmark(facilityScanCode.id);
    _isBookmark.value = !_isBookmark.value;
  }
}
