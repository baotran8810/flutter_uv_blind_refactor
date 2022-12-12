import 'package:flutter_uv_blind_refactor/data_access/dtos/app_setting/app_setting_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/app_setting_repository/app_setting_repository.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/setting_scan_page/setting_scan_page_controller.dart';
import 'package:get/get.dart';

class SettingScanPageControllerImpl extends GetxController
    implements SettingScanPageController {
  final RxInt _borderLevel = 0.obs;
  @override
  int get selectedBorderLevelIndex => _borderLevel.value;

  final RxInt _selectedColor = 0.obs;
  @override
  int get selectedColorIndex => _selectedColor.value;

  final AppSettingRepository _appSettingRepository;

  SettingScanPageControllerImpl({
    required AppSettingRepository appSettingRepository,
  }) : _appSettingRepository = appSettingRepository;

  late AppSettingDto _appSettingDto;

  @override
  Future<void> onInit() async {
    _appSettingDto = await _appSettingRepository.getAppSetting();
    _selectedColor.value = _appSettingDto.colorIndex;

    _borderLevel.value = _appSettingDto.borderLevelIndex;

    super.onInit();
  }

  @override
  Future<void> selectBorderLevel(int x) async {
    _borderLevel.value = x;
    _appSettingRepository.saveSetting(borderLevelIndex: x);
  }

  @override
  Future<void> selectColor(int x) async {
    _selectedColor.value = x;
    _appSettingRepository.saveSetting(colorIndex: x);
  }
}
