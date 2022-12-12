import 'dart:async';
import 'dart:io';

import 'package:background_location/background_location.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/a11y_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/angle_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/location_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/app_setting/app_setting_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/app_setting_repository/app_setting_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/hardware_service/hardware_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_life_cycle/app_life_cycle_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/navi_compass_page/navi_compass_page_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shake/shake.dart';

const double _correctAngleDegree = 15;

class NaviCompassPageControllerImpl extends AppLifeCycleController
    implements NaviCompassPageController {
  final SpeakingService _speakingService;
  final AppSettingRepository _appSettingRepository;
  final HardwareService _hardwareService;
  // Arguments
  final String courseName;
  final List<PointDto> pointList;

  NaviCompassPageControllerImpl({
    required this.courseName,
    required this.pointList,
    required SpeakingService speakingService,
    required AppSettingRepository appSettingRepository,
    required HardwareService hardwareService,
  })  : _speakingService = speakingService,
        _appSettingRepository = appSettingRepository,
        _hardwareService = hardwareService;

  late final Rx<PointDto> _headingPoint;
  @override
  PointDto get headingPoint => _headingPoint.value;

  final Rx<AppLocationStatus> _locationStatus = AppLocationStatus.notAsked.obs;
  @override
  AppLocationStatus get locationStatus => _locationStatus.value;

  /// null: when loading & when permission denied
  final Rx<CoordinateDto?> _currentCoordinate = Rx(null);
  @override
  CoordinateDto? get currentCoordinate => _currentCoordinate.value;

  final Rx<double?> _currentAccuracy = Rx(null);
  @override
  double? get currentAccuracy => _currentAccuracy.value;

  final Rx<bool> _isLoadingAngle = true.obs;
  @override
  bool get isLoadingAngle => _isLoadingAngle.value;

  /// null: when loading & when device doesn't support sensor
  final Rx<double?> _angleDegree = Rx(null);
  @override
  double? get angleDegree => _angleDegree.value;

  final AudioPlayer _audioPlayer = AudioPlayer();

  StreamSubscription? _positionSub;
  StreamSubscription? _compassSub;
  ShakeDetector? _shakeDetector;

  bool _hasDoneSpeakSemanticsTitle = false;
  bool _hasStartSpeakIntro = false; // For intro check
  bool _hasDoneSpeakIntro = false; // For out of course check
  bool _hasAlertOutOfCourse = false;
  bool _hasAlertCorrectAngle = false;
  bool _hasReachedFinalDestination = false;

  late final AppSettingDto _appSetting;

  @override
  Future<void> onInit() async {
    super.onInit();

    _headingPoint = Rx(pointList[0]);

    final bool isAllow = await _requestLocationPermission();
    if (isAllow == false) {
      return;
    }

    _appSetting = await _appSettingRepository.getAppSetting();

    _setupListeners();

    // A dirty workaround prevent intro from overlapping with
    // voiceover/talkback initial focus. Duration is duration
    // of title's semantics label
    // TODO find a better way
    if (await A11yUtils.isBlindModeOn()) {
      Future.delayed(Duration(milliseconds: 6000), () {
        _hasDoneSpeakSemanticsTitle = true;
      });
    } else {
      _hasDoneSpeakSemanticsTitle = true;
    }
  }

  @override
  void onClose() {
    if (Platform.isAndroid) {
      BackgroundLocation.stopLocationService();
    }
    _shakeDetector?.stopListening();
    _positionSub?.cancel();
    _compassSub?.cancel();
    _audioPlayer.dispose();

    super.onClose();
  }

  Future<bool> _requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _locationStatus.value = AppLocationStatus.denied;
      return false;
    } else {
      _locationStatus.value = AppLocationStatus.loading;
      return true;
    }
  }

  Future<void> _speak(List<String> sentenceList) async {
    if (_appSetting.voiceGuide == false) {
      return;
    }

    await _speakingService.speakSentences(
      sentenceList.map((sentence) => SpeakItem(text: sentence)).toList(),
      doCacheFile: false,
      speed: _appSetting.voiceGuideSpeed,
    );
  }

  Future<void> _speakIntroIfPossible() async {
    if (!_hasDoneSpeakSemanticsTitle) {
      return;
    }

    if (_hasStartSpeakIntro == true ||
        currentCoordinate == null ||
        angleDegree == null) {
      return;
    }

    _hasStartSpeakIntro = true;
    await _speakHeadingPointInformation(speakIntro: true);
    _hasDoneSpeakIntro = true;
  }

  Future<void> _speakHeadingPointInformation({
    bool speakIntro = false,
  }) async {
    if (currentCoordinate == null || angleDegree == null) {
      return;
    }

    final distanceInMeter = LocationUtils.getDistanceInMeters(
      startCoord: currentCoordinate!,
      endCoord: headingPoint.coordinate,
    );

    final angleClock = AngleUtils.getClockFromDegree(angleDegree!);

    final String introText = tra(
      LocaleKeys.semTxt_naviIntroWA,
      namedArgs: {
        'courseName': courseName,
      },
    );

    final String nextPointText = tra(
      LocaleKeys.semTxt_naviNextPointWA,
      namedArgs: {
        'pointName': headingPoint.pointName,
        'angleClock': angleClock.toString(),
        'distanceInMeter': distanceInMeter.toStringAsFixed(0),
      },
    );

    await _speak([
      if (speakIntro) introText,
      nextPointText,
    ]);
  }

  /// Setup listeners for Location, Compass, Phone Shake
  void _setupListeners() {
    if (FlutterCompass.events == null) {
      // TODO handle this
      print('Error null');
      return;
    }

    if (Platform.isAndroid) {
      BackgroundLocation.startLocationService();
    }

    // * Listen to location
    _positionSub = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    ).listen((position) {
      _onLocationChanged(position);
      _speakIntroIfPossible();
    });

    // * Listen to heading angle
    _isLoadingAngle.value = true;
    _compassSub = FlutterCompass.events?.listen((compassEvent) {
      _onHeadingChanged(compassEvent);
      _speakIntroIfPossible();
    });

    // * Listen to phone shake
    if (_appSetting.voiceGuidanceWithShake) {
      _shakeDetector = ShakeDetector.autoStart(
        onPhoneShake: () {
          _hardwareService.vibrate();
          _speakHeadingPointInformation();
        },
      );
    }
  }

  // * Position listener
  void _onLocationChanged(Position position) {
    _locationStatus.value = AppLocationStatus.loaded;

    _currentCoordinate.value = CoordinateDto(
      latitude: position.latitude,
      longitude: position.longitude,
    );
    _currentAccuracy.value = position.accuracy;

    _checkHasReachedHeadingPoint(currentCoordinate!);
    _checkOutOfCourse(currentCoordinate!);
  }

  void _checkHasReachedHeadingPoint(CoordinateDto currentCoord) {
    final double distanceInMeters = LocationUtils.getDistanceInMeters(
      startCoord: currentCoord,
      endCoord: headingPoint.coordinate,
    );

    if (distanceInMeters <= _appSetting.radiusGPS) {
      _setToNextPointOrCheckIn();
    }
  }

  /// - If non-final point: set headingPoint to next point & speak its info
  /// - If final point: keep repeating arrival speak
  Future<void> _setToNextPointOrCheckIn() async {
    final int currentHeadingPointIndex = pointList.indexOf(headingPoint);

    // * Final destination
    if (currentHeadingPointIndex == pointList.length - 1) {
      if (_hasReachedFinalDestination) {
        return;
      }

      _hasReachedFinalDestination = true;

      // Speak arrival script
      final script = tra(
        LocaleKeys.semTxt_naviArrivalWA,
        namedArgs: {
          'pointName': headingPoint.pointName,
        },
      );
      await _speak([script]);

      // To repeat the speak every x secs if still in check-in range
      Future.delayed(Duration(seconds: 10), () {
        _hasReachedFinalDestination = false;
      });
    }
    // * Non-final destination
    else {
      final oldHeadingPoint = headingPoint;
      _headingPoint.value = pointList[currentHeadingPointIndex + 1];

      final script = tra(
        LocaleKeys.semTxt_naviCheckInWA,
        namedArgs: {
          'pointName': oldHeadingPoint.pointName,
        },
      );
      await _speak([script]);

      await _speakHeadingPointInformation();
    }
  }

  void _checkOutOfCourse(CoordinateDto currentCoord) {
    if (_hasDoneSpeakIntro == false) {
      return;
    }

    double outOfCourseDistance;

    final int headingPointIndex = pointList.indexOf(headingPoint);
    // Calculate outOfCourse if there's no previous point
    if (headingPointIndex == 0) {
      outOfCourseDistance = LocationUtils.getDistanceInMeters(
        startCoord: currentCoord,
        endCoord: headingPoint.coordinate,
      );
    }
    // Calculate outOfCourse if there is previous point
    else {
      final PointDto startPoint = pointList[headingPointIndex - 1];
      outOfCourseDistance = LocationUtils.calculateOutOfCourseFromCoords(
        coordCurrent: currentCoord,
        coordA: startPoint.coordinate,
        coordB: headingPoint.coordinate,
      );
    }

    if (outOfCourseDistance > _appSetting.distanceOutOfRange) {
      _alertOutOfCourse();
    } else {
      _hasAlertOutOfCourse = false;
    }
  }

  void _alertOutOfCourse() {
    if (_hasAlertOutOfCourse == false) {
      _hasAlertOutOfCourse = true;
      _speak([tra(LocaleKeys.semTxt_naviOutOfCourse)]);
    }
  }

  // * Compass listener
  void _onHeadingChanged(CompassEvent compassEvent) {
    final double? headingDegree = compassEvent.heading;
    if (headingDegree == null) {
      return;
    }

    _isLoadingAngle.value = false;

    _setAngleDegree(headingDegree);
  }

  void _setAngleDegree(double headingDegree) {
    if (currentCoordinate == null) {
      return;
    }

    final double bearingDegree = LocationUtils.getBearingDegree(
      startCoord: currentCoordinate!,
      endCoord: headingPoint.coordinate,
    );

    _angleDegree.value = (bearingDegree - headingDegree) % 360;

    if (angleDegree != null) {
      if (angleDegree! >= 360 - _correctAngleDegree ||
          angleDegree! <= 0 + _correctAngleDegree) {
        _alertCorrectAngle();
      } else {
        _hasAlertCorrectAngle = false;
      }
    }
  }

  void _alertCorrectAngle() {
    if (_hasAlertCorrectAngle == false) {
      _hasAlertCorrectAngle = true;
      _hardwareService.vibrate();
      _playCorrectSound();
    }
  }

  Future<void> _playCorrectSound() async {
    await _audioPlayer.setAsset(AppSoundAssets.soundAlarm);

    try {
      _audioPlayer.play();
    } catch (e) {
      print(e);
      // Avoid lib unnecessary exception
    }
  }

  /// Find the nearest point & assign to heading point
  @override
  void refreshHeadingPoint() {
    if (currentCoordinate == null) {
      return;
    }

    PointDto nearestPoint = pointList[0];
    double nearestPointDistance = LocationUtils.getDistanceInMeters(
      startCoord: currentCoordinate!,
      endCoord: nearestPoint.coordinate,
    );

    for (final point in pointList) {
      final double pointDistance = LocationUtils.getDistanceInMeters(
        startCoord: currentCoordinate!,
        endCoord: point.coordinate,
      );

      if (pointDistance < nearestPointDistance) {
        nearestPoint = point;
        nearestPointDistance = pointDistance;
      }
    }

    _headingPoint.value = nearestPoint;
    _speakHeadingPointInformation();
  }

  @override
  void openMap() {
    if (currentCoordinate == null) {
      return;
    }

    MapsLauncher.launchCoordinates(
      currentCoordinate!.latitude,
      currentCoordinate!.longitude,
    );
  }
}
