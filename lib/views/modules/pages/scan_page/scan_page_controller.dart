import 'package:flutter_camera_uv_decoder/flutter_camera_uv_decoder.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_life_cycle/app_route_aware_controller_mixin.dart';

abstract class ScanPageController with AppRouteAwareControllerMixin {
  CameraController get cameraController;
  bool get cameraIsWork;
  int get brightness;
  UVRect? get points;

  void dispose();
  int get borderColor;
  int get borderLevel;
}

// === UVRect for drawing Bounding Box

class UVRect {
  final double? tlX;
  final double? tlY;
  final double? trX;
  final double? trY;
  final double? brX;
  final double? brY;
  final double? blX;
  final double? blY;

  UVRect({
    this.tlX,
    this.tlY,
    this.trX,
    this.trY,
    this.brX,
    this.brY,
    this.blX,
    this.blY,
  });
}
