import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/point_entity/coordinate_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/point_entity/point_entity.dart';
import 'package:geolocator/geolocator.dart';

class PointDto {
  final String id;

  final String pointName;

  final String? pointInfo;

  final String? beaconId;

  final CoordinateDto coordinate;

  final List<PointCategoryDto> categoryList;

  PointDto({
    required this.id,
    required this.pointName,
    required this.pointInfo,
    required this.beaconId,
    required this.coordinate,
    required List<String> categoryIdStrList,
  }) : categoryList = categoryIdStrList
            .map((categoryId) => PointCategoryDto.fromCategoryId(categoryId))
            .toList();

  factory PointDto.fromEntity(PointEntity entity) {
    return PointDto(
      id: entity.id,
      pointName: entity.pointName,
      pointInfo: entity.pointInfo,
      beaconId: entity.beaconId,
      coordinate: CoordinateDto.fromEntity(entity.coordinate),
      categoryIdStrList: entity.categoryList,
    );
  }

  PointEntity toEntity() {
    return PointEntity(
      pointName: pointName,
      pointInfo: pointInfo,
      beaconId: beaconId,
      coordinate: coordinate.toEnity(),
      categoryList: categoryList
          .map((category) => category.categoryId.toString())
          .toList(),
    );
  }
}

class CoordinateDto {
  final double latitude;
  final double longitude;

  const CoordinateDto({
    required this.latitude,
    required this.longitude,
  });

  factory CoordinateDto.fromPosition(Position position) {
    return CoordinateDto(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  factory CoordinateDto.fromEntity(CoordinateEntity entity) {
    return CoordinateDto(
        latitude: entity.latitude, longitude: entity.longitude);
  }

  CoordinateEntity toEnity() {
    return CoordinateEntity(latitude: latitude, longitude: longitude);
  }
}

class PointCategoryDto {
  final int categoryId;
  final PointCategoryType categoryType;

  PointCategoryDto({
    required this.categoryId,
    required this.categoryType,
  });

  factory PointCategoryDto.fromCategoryId(String categoryIdStr) {
    final int categoryId = int.parse(categoryIdStr);

    final PointCategoryType? foundType = _categoryIdMap[categoryId];

    if (foundType == null) {
      throw Exception('Missing category mapping');
    }

    return PointCategoryDto(
      categoryId: categoryId,
      categoryType: foundType,
    );
  }
}

Map<int, PointCategoryType> _categoryIdMap = {
  1: PointCategoryType.institution,
  2: PointCategoryType.accommodation,
  3: PointCategoryType.transportation,
  4: PointCategoryType.shrine,
  5: PointCategoryType.restaurant,
  6: PointCategoryType.shopping,
  7: PointCategoryType.medical,
  8: PointCategoryType.sightseeing,
  9: PointCategoryType.government,
  10: PointCategoryType.school,
  11: PointCategoryType.convenienceStore,
  12: PointCategoryType.gasStation,
  13: PointCategoryType.postBox,
  14: PointCategoryType.museum,
  15: PointCategoryType.scenicSites,
  16: PointCategoryType.naturalScenery,
  17: PointCategoryType.workshop,
  18: PointCategoryType.church,
  201: PointCategoryType.evacShelter,
  202: PointCategoryType.shelter,
  203: PointCategoryType.publicPhone,
  204: PointCategoryType.specialPhone,
  205: PointCategoryType.waterStation,
  206: PointCategoryType.publicRestroom,
  207: PointCategoryType.tempStayFacility,
  208: PointCategoryType.shortTermEva,
  209: PointCategoryType.socialWelfareInstitutionEva,
  210: PointCategoryType.aed,
  211: PointCategoryType.tsunamiEva,
  212: PointCategoryType.policeStation,
  213: PointCategoryType.fireStation,
  214: PointCategoryType.hospital,
  215: PointCategoryType.disasterEmergencyHospital,
  216: PointCategoryType.emergencyHelicopter,
  217: PointCategoryType.fireHydrant,
  301: PointCategoryType.stadium,
};
