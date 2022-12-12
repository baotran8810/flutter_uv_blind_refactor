import 'dart:async';

import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/location_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/location_service/location_service.dart';

class LocationServiceImpl implements LocationService {
  @override
  Future<CoordinateDto> getCurrentCoordinate() async {
    final position = await LocationUtils.getCurrentPosition();
    return CoordinateDto.fromPosition(position);
  }

  @override
  Future<double> getHeadingDegree() async {
    final completer = Completer<double>();

    // ignore: cancel_subscriptions
    StreamSubscription? sub;
    sub = FlutterCompass.events?.listen((compassEvent) {
      completer.complete(compassEvent.heading);

      // Somehow, it only works if we pause() instead of cancel()
      // TODO find out why and cancel properly
      sub?.pause();
      // sub?.cancel();
    });

    return completer.future;
  }
}
