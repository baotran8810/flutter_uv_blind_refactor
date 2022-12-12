import 'package:flutter_uv_blind_refactor/common/utility/utils/location_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_dto.dart';

/// Add some extended mutable fields
/// to use in Controller/View layer
///
class PointAppDto extends PointDto {
  double? distanceToCurLocation;
  double? angleDegree;

  PointAppDto({
    required this.distanceToCurLocation,
    required this.angleDegree,
    required PointDto rawDto,
  }) : super(
          id: rawDto.id,
          pointName: rawDto.pointName,
          pointInfo: rawDto.pointInfo,
          beaconId: rawDto.beaconId,
          coordinate: rawDto.coordinate,
          categoryIdStrList:
              rawDto.categoryList.map((x) => x.categoryId.toString()).toList(),
        );

  factory PointAppDto.fromRawDto(PointDto rawDto) {
    return PointAppDto(
      distanceToCurLocation: null,
      angleDegree: null,
      rawDto: rawDto,
    );
  }

  /// Mutate
  void applyDistanceAndAngle({
    required CoordinateDto currentCoordinate,
    required double headingDegree,
  }) {
    distanceToCurLocation = LocationUtils.getDistanceInMeters(
      startCoord: currentCoordinate,
      endCoord: coordinate,
    );

    final double bearingDegree = LocationUtils.getBearingDegree(
      startCoord: currentCoordinate,
      endCoord: coordinate,
    );

    angleDegree = (bearingDegree - headingDegree) % 360;
  }
}
