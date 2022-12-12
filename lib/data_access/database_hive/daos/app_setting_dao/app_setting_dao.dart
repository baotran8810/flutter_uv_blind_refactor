import 'package:flutter_uv_blind_refactor/data_access/dtos/app_setting/app_setting_dto.dart';

abstract class AppSettingDao {
  Future<AppSettingDto> getAppSetting();
  Future<AppSettingDto> saveAppSetting(AppSettingDto dto);
}
