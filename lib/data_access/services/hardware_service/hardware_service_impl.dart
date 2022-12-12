import 'package:flutter_uv_blind_refactor/data_access/repositories/app_setting_repository/app_setting_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/hardware_service/hardware_service.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';

class HardwareServiceImpl implements HardwareService {
  final AppSettingRepository _appSettingRepository;

  HardwareServiceImpl({
    required AppSettingRepository appSettingRepository,
  }) : _appSettingRepository = appSettingRepository;

  @override
  Future<void> vibrate({
    Duration duration = const Duration(milliseconds: 500),
  }) async {
    final appSetting = await _appSettingRepository.getAppSetting();

    if (appSetting.vibration == false) {
      return;
    }

    Vibration.vibrate(duration: duration.inMilliseconds);
  }

  @override
  Future<void> enableWakelock() async {
    await Wakelock.enable();
  }

  @override
  Future<void> disableWakelock() async {
    await Wakelock.disable();
  }
}
