import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/app_setting/app_setting_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/address_repository/address_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/app_setting_repository/app_setting_repository.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/setting_controller/setting_controller.dart';
import 'package:get/get.dart';

class SettingControllerImpl extends GetxController
    implements SettingController {
  final AppSettingRepository _appSettingRepository;
  final AddressRepository _addressRepository;

  SettingControllerImpl({
    required AppSettingRepository appSettingRepository,
    required AddressRepository addressRepository,
  })  : _appSettingRepository = appSettingRepository,
        _addressRepository = addressRepository;

  /// Only `null` for a short amount of time when init
  final Rx<AppSettingDto?> _appSetting = Rx(null);

  @override
  AppSettingDto? get appSetting => _appSetting.value;

  final Rx<String?> _currentAddress = Rx(null);

  @override
  String? get currentAddress => _currentAddress.value;

  @override
  Future<void> onInit() async {
    final initialAppSetting = await _appSettingRepository.getAppSetting();
    _appSetting.value = initialAppSetting;

    _loadAddress();

    super.onInit();
  }

  @override
  Future<void> setAudioPlayBackSpeed(double val) async {
    _appSetting.value = await _appSettingRepository.saveSetting(
      voiceGuideSpeed: val,
    );
  }

  @override
  Future<void> setContinuousScan(bool value) async {
    _appSetting.value = await _appSettingRepository.saveSetting(
      continuousScan: value,
    );
  }

  @override
  Future<void> setDistanceOutOfRange(int value) async {
    _appSetting.value = await _appSettingRepository.saveSetting(
      distanceOutOfRange: value,
    );
  }

  @override
  Future<void> setFlashLight(bool value) async {
    _appSetting.value = await _appSettingRepository.saveSetting(
      flashlight: value,
    );
  }

  @override
  Future<void> setReadingGender(Gender value) async {
    _appSetting.value = await _appSettingRepository.saveSetting(
      readingGender: value,
    );
  }

  @override
  Future<void> setRadiusGPS(int value) async {
    _appSetting.value = await _appSettingRepository.saveSetting(
      radiusGPS: value,
    );
  }

  @override
  Future<void> setSoundApp(bool value) async {
    _appSetting.value = await _appSettingRepository.saveSetting(
      soundApp: value,
    );
  }

  @override
  Future<void> setVibrate(bool value) async {
    _appSetting.value = await _appSettingRepository.saveSetting(
      vibration: value,
    );
  }

  @override
  Future<void> setVoiceGuidanceWithShake(bool value) async {
    _appSetting.value = await _appSettingRepository.saveSetting(
      voiceGuidanceWithShake: value,
    );
  }

  @override
  Future<void> setVoiceGuide(bool value) async {
    _appSetting.value = await _appSettingRepository.saveSetting(
      voiceGuide: value,
    );
  }

  @override
  void reloadAddress() {
    _loadAddress();
  }

  void _loadAddress() {
    final currentAddress = _addressRepository.getCurrentAddressName();
    _currentAddress.value = currentAddress;
  }

  @override
  Future<void> setAudioReadingSpeed(double value) async {
    _appSetting.value = await _appSettingRepository.saveSetting(
      audioReadingSpeed: value,
    );
  }

  @override
  Future<void> setVoicePitch(double value) async {
    _appSetting.value = await _appSettingRepository.saveSetting(
      voicePitch: value,
    );
  }

  @override
  Future<void> setSignLanguage(bool value) async {
    _appSetting.value = await _appSettingRepository.saveSetting(
      signLanguage: value,
    );
  }

  @override
  Future<void> setAppVoice(AppVoice value) async {
    _appSetting.value = await _appSettingRepository.saveSetting(
      appVoice: value,
    );
  }

  @override
  Future<void> setIsAutoplayReading(bool value) async {
    _appSetting.value = await _appSettingRepository.saveSetting(
      isAutoplayReading: value,
    );
  }
}
