import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_dto.dart';

abstract class LocationService {
  Future<CoordinateDto> getCurrentCoordinate();
  Future<double> getHeadingDegree();
}
