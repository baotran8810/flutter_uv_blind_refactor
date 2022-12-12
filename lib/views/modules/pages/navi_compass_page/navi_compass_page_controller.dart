import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_dto.dart';

abstract class NaviCompassPageController {
  PointDto get headingPoint;

  AppLocationStatus get locationStatus;

  /// null: when loading & when permission denied
  CoordinateDto? get currentCoordinate;

  /// null: when loading & when permission denied
  double? get currentAccuracy;

  bool get isLoadingAngle;

  /// null: when loading & when device doesn't support sensor
  double? get angleDegree;

  /// Find the nearest point & assign to heading point
  void refreshHeadingPoint();
  void openMap();
}
