import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_dto.dart';

abstract class NaviDirectionPageController {
  /// Already applied reverse
  List<PointDto> get pointList;

  AppLocationStatus get locationStatus;
  CoordinateDto? get startCoordinate;

  void toggleRevert();
  Future<void> choosePoint(String id);
}
