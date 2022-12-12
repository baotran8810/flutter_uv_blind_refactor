import 'dart:math';

import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_dto.dart';
import 'package:geolocator/geolocator.dart';

class LocationUtils {
  static Future<Position> getCurrentPosition() async {
    return await Geolocator.getPositionStream().first;
  }

  static double getDistanceInMeters({
    required CoordinateDto startCoord,
    required CoordinateDto endCoord,
  }) {
    return Geolocator.distanceBetween(
      startCoord.latitude,
      startCoord.longitude,
      endCoord.latitude,
      endCoord.longitude,
    );
  }

  /// Assume that the walk speed is 80m/minute
  static double getEstimateTimeInMinutes(double distanceInMeters) {
    return distanceInMeters / 80;
  }

  static double getBearingDegree({
    required CoordinateDto startCoord,
    required CoordinateDto endCoord,
  }) {
    return Geolocator.bearingBetween(
      startCoord.latitude,
      startCoord.longitude,
      endCoord.latitude,
      endCoord.longitude,
    );
  }

  static double _calculateOutOfCourse(double a, double b, double c) {
    final double s = (a + b + c) / 2;
    final double area = sqrt(s * (s - a) * (s - b) * (s - c));
    final double height = (2 * area) / a;
    final double wrongDistance = max(height, c - a);
    return max(wrongDistance, b - a);
  }

  static double calculateOutOfCourseFromCoords({
    required CoordinateDto coordCurrent,
    required CoordinateDto coordA,
    required CoordinateDto coordB,
  }) {
    final double distanceToStart = getDistanceInMeters(
      startCoord: coordCurrent,
      endCoord: coordA,
    );

    final double distanceToEnd = getDistanceInMeters(
      startCoord: coordCurrent,
      endCoord: coordB,
    );

    final distanceFromStartToEnd = getDistanceInMeters(
      startCoord: coordA,
      endCoord: coordB,
    );

    return _calculateOutOfCourse(
      distanceFromStartToEnd,
      distanceToStart,
      distanceToEnd,
    );
  }
}
