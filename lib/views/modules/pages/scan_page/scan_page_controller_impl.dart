import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/services.dart';
import 'package:flutter_camera_uv_decoder/flutter_camera_uv_decoder.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/device_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/log_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/dialog_view_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/scan_code_view_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/startup_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/app_setting/app_setting_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/app_setting_repository/app_setting_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/scan_code_repository/scan_code_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/analytics_service/analytics_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/hardware_service/hardware_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/scan_decode_service/scan_decode_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/sign_language_url/sign_language_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:flutter_uv_blind_refactor/main.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_life_cycle/app_life_cycle_controller.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_life_cycle/app_route_aware_controller_mixin.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/scan_page/scan_page_controller.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

enum _ScanSoundLoop {
  normal,
  lowBrightness,
  highBrightness,
}

class ScanPageControllerImpl extends AppLifeCycleController
    with AppRouteAwareControllerMixin
    implements ScanPageController {
  final AnalyticsService _analyticsService;
  final ScanCodeRepository _scanCodeRepository;
  final ScanDecodeService _scanDecodeService;
  final AppSettingRepository _appSettingRepository;
  final SignLanguageService _signLanguageService;
  final SpeakingService _speakingService;
  final HardwareService _hardwareService;

  ScanPageControllerImpl({
    required AnalyticsService analyticsService,
    required AppSettingRepository appSettingRepository,
    required ScanCodeRepository scanCodeRepository,
    required ScanDecodeService scanDecodeService,
    required SignLanguageService signLanguageService,
    required SpeakingService speakingService,
    required HardwareService hardwareService,
  })  : _analyticsService = analyticsService,
        _appSettingRepository = appSettingRepository,
        _scanCodeRepository = scanCodeRepository,
        _scanDecodeService = scanDecodeService,
        _signLanguageService = signLanguageService,
        _speakingService = speakingService,
        _hardwareService = hardwareService;

  late CameraController _cameraController;
  @override
  CameraController get cameraController => _cameraController;

  final RxBool _cameraIsWork = false.obs;
  @override
  bool get cameraIsWork => _cameraIsWork.value;

  final RxInt _brightness = 0.obs;
  @override
  int get brightness => _brightness.value;

  final Rx<UVRect?> _points = Rx(null);
  @override
  UVRect? get points => _points.value;

  final RxInt _borderColor = 0.obs;
  @override
  int get borderColor => _borderColor.value;

  final RxInt _borderLevel = 0.obs;
  @override
  int get borderLevel => _borderLevel.value;

  late AudioPlayer _loopAudioPlayer;
  late AudioPlayer _captureAudioPlayer;
  late AppSettingDto _appSettingDto;

  @override
  Future<void> onInit() async {
    super.onInit();

    _removeRect();
    await _init();

    // TODO Consider moving these stuff into splash page
    StartupViewUtils.initStartup(
      notificationRepository: Get.find(),
      scanCodeRepository: Get.find(),
      analyticsService: Get.find(),
      pushNotifService: Get.find(),
      scanDecodeService: Get.find(),
      appInfoController: Get.find(),
      notificationsController: Get.find(),
    );
  }

  @override
  void onClose() {
    _dispose();

    super.onClose();
  }

  @override
  void onAppPause() {
    if (Get.currentRoute == AppRoutes.scan) {
      _dispose();
    }
  }

  @override
  void onAppResume() {
    if (Get.currentRoute == AppRoutes.scan) {
      _init();
    }
  }

  @override
  void onPushNext() {
    _dispose();
  }

  @override
  void onPopNext() {
    _init();
  }

  Future<void> _init() async {
    _cameraIsWork.value = false;

    _appSettingDto = await _appSettingRepository.getAppSetting();
    _borderColor.value = _appSettingDto.colorIndex;
    _borderLevel.value = _appSettingDto.borderLevelIndex;

    _loopAudioPlayer = AudioPlayer(handleInterruptions: false);
    _captureAudioPlayer = AudioPlayer(handleInterruptions: false);

    // Delay init functions because it is heavy to run on main thread
    // which may cause janky transitions issue
    await Future.delayed(Duration(milliseconds: 500));

    await _initSound();
    await _initCamera();

    _loopAudioPlayer.play();

    _cameraIsWork.value = true;
    _hardwareService.enableWakelock();
  }

  Future<void> _dispose() async {
    _cameraIsWork.value = false;

    try {
      await _loopAudioPlayer.stop();
    } catch (e) {
      //
    }

    _setFlashMode(FlashMode.off);

    await _cameraController.stopImageStream();

    // Delay dispose functions because it is heavy to run on main thread
    // which may cause janky transitions issue
    await Future.delayed(Duration(milliseconds: 500));

    await Future.wait([
      _loopAudioPlayer.dispose(),
      _cameraController.dispose(),
    ]);

    _hardwareService.disableWakelock();
  }

  Future _initCamera() async {
    final ResolutionPreset cameraResolution;
    if (DeviceUtils.isIphoneXOrNewer()) {
      cameraResolution = ResolutionPreset.veryHigh;
    } else {
      cameraResolution = ResolutionPreset.high;
    }

    _cameraController = CameraController(
      cameras[0],
      // This argument is currently not working on Android
      cameraResolution,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      await _cameraController.initialize();
    } on CameraException {
      // TODO rework permission checking
      await _checkCameraPermission();
      return;
    }

    // Fix camera orientation on iPad
    if (Platform.isIOS) {
      await cameraController
          .lockCaptureOrientation(DeviceOrientation.portraitUp);
    }

    _setFlashMode(
      _appSettingDto.flashlight ? FlashMode.torch : FlashMode.off,
    );

    _startImageStream();
  }

  Future<void> _setFlashMode(FlashMode flashMode) async {
    try {
      await _cameraController.setFlashMode(flashMode);
    } catch (e) {
      LogUtils.iNoST('Camera flash mode not supported');
    }
  }

  Future<void> _removeRect() async {
    _points(
      UVRect(
        tlX: -10,
        tlY: -10,
        trX: -10,
        trY: -10,
        blX: -10,
        blY: -10,
        brX: -10,
        brY: -10,
      ),
    );
  }

  Future<void> _initSound() async {
    await Future.wait([
      _loopAudioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          children: [
            ..._ScanSoundLoop.values.map((scanSoundLoop) {
              final String assetUrl;
              switch (scanSoundLoop) {
                case _ScanSoundLoop.normal:
                  assetUrl = "asset:///${AppSoundAssets.soundCensorBeep}";
                  break;
                case _ScanSoundLoop.lowBrightness:
                  assetUrl = "asset:///${AppSoundAssets.soundLowBrightness}";
                  break;
                case _ScanSoundLoop.highBrightness:
                  assetUrl = "asset:///${AppSoundAssets.soundOverBrightness}";
                  break;
              }
              return AudioSource.uri(Uri.parse(assetUrl));
            }).toList(),
          ],
        ),
      ),
      _captureAudioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse("asset:///${AppSoundAssets.soundCapture}")),
      )
    ]);
    await _loopAudioPlayer.setLoopMode(LoopMode.one);

    if (_appSettingDto.soundApp) {
      await _loopAudioPlayer.setVolume(0);
    } else {
      await _loopAudioPlayer.setVolume(0.2);
    }
  }

  void _startImageStream() {
    _cameraController.startImageStream((Data? data) {
      _points.value = UVRect(
        tlX: data?.tlX,
        tlY: data?.tlY,
        trX: data?.trX,
        trY: data?.trY,
        blX: data?.blX,
        blY: data?.blY,
        brX: data?.brX,
        brY: data?.brY,
      );
      _brightness.value = data?.brightness ?? 0;
      _changeSound();

      final scanResult = data?.result;
      final codeHeader = data?.codeHeader;
      if (scanResult != null) {
        _handleRawResult(scanResult, codeHeader);
      }
    });
  }

  Future<void> _handleRawResult(String source, String? codeHeader) async {
    if (source.trim().isEmpty) {
      return;
    }

    await _cameraController.stopImageStream();
    await _loopAudioPlayer.pause();

    // This includes waiting for the capture sound to complete
    await _playSoundAndVibrate();

    final decodeResult = await _scanDecodeService.decodeFromString(
      source,
      logEventHandler: (scanCode) {
        _analyticsService.logDecodeScanCode(
          decodeSource: DecodeSource.scanning,
          codeName: scanCode.name,
          codeInfo: scanCode.codeInfo,
        );
      },
    );

    if (decodeResult == null) {
      _loopAudioPlayer.play();
      _startImageStream();
      return;
    }

    // Scan multiple codes
    if (_appSettingDto.continuousScan) {
      _scanCodeRepository.addOrUpdateScanCodeList(decodeResult.scanCodeList);

      await _speakingService.speakSentences(
        [SpeakItem(text: tra(LocaleKeys.semTxt_scanNextCode))],
      );

      _loopAudioPlayer.play();
      _startImageStream();
    }
    // Scan only 1 code
    else {
      await _scanCodeRepository
          .addOrUpdateScanCodeList(decodeResult.scanCodeList);

      String? signLanguageURL;
      if (codeHeader != null) {
        signLanguageURL = await _signLanguageService.getSignLanguageUrl(
          codeHeader,
        );
      }

      await ScanCodeViewUtils.goToScanCodePage(
        decodeResult.scanCodeList,
        signLanguageURL: signLanguageURL,
      );
    }
  }

  /// Play capture sound & vibrate
  Future<void> _playSoundAndVibrate() async {
    await _hardwareService.vibrate();
    await _captureAudioPlayer.seek(Duration.zero);
    await _captureAudioPlayer.play();
  }

  void _changeSound() {
    final int? currentAudioIndex = _loopAudioPlayer.currentIndex;
    if (_brightness.value == -1) {
      // Brightness too low

      if (currentAudioIndex != _ScanSoundLoop.lowBrightness.index) {
        _loopAudioPlayer.seek(
          Duration.zero,
          index: _ScanSoundLoop.lowBrightness.index,
        );
      }
    } else if (_brightness.value == 1) {
      // Brightness too high

      if (currentAudioIndex != _ScanSoundLoop.highBrightness.index) {
        _loopAudioPlayer.seek(
          Duration.zero,
          index: _ScanSoundLoop.highBrightness.index,
        );
      }
    } else {
      // Normal condition

      if (currentAudioIndex != _ScanSoundLoop.normal.index) {
        _loopAudioPlayer.seek(
          Duration.zero,
          index: _ScanSoundLoop.normal.index,
        );
      }

      // Play sound faster if bounding box detected
      if (points!.tlX != null && points!.tlX != 0) {
        _loopAudioPlayer.setSpeed(2);
      } else {
        _loopAudioPlayer.setSpeed(1);
      }
    }
  }

  Future<void> _checkCameraPermission() async {
    if (await Permission.camera.isPermanentlyDenied) {
      if (Platform.isIOS) {
        final isConfirmed = await DialogViewUtils.showConfirmDialog(
            messageText: tra(LocaleKeys.txt_cameraDialogMessage),
            titleText: tra(LocaleKeys.txt_cameraDialogTitle),
            textYes: tra(LocaleKeys.btn_setting),
            textNo: tra(LocaleKeys.btn_later));
        if (!isConfirmed) {
          return;
        }
        await AppSettings.openAppSettings();
      }
    }
  }
}
