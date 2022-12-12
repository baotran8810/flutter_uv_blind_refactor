import 'package:flutter_uv_blind_refactor/data_access/database_hive/app_hive.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/app_setting_dao/app_setting_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/app_setting/app_setting_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/app_setting/app_setting_dto.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AppSettingDaoImpl implements AppSettingDao {
  final Box<AppSettingEntity> _appSettingEntity;

  AppSettingDaoImpl()
      : _appSettingEntity = Get.find<AppHive>().getBox<AppSettingEntity>() {
    // Init a record in db
    getAppSetting();
  }

  @override
  Future<AppSettingDto> getAppSetting() async {
    if (_appSettingEntity.values.isEmpty) {
      return await saveAppSetting(AppSettingDto.initDefault());
    }

    return AppSettingDto.fromEntity(_appSettingEntity.values.first);
  }

  @override
  Future<AppSettingDto> saveAppSetting(AppSettingDto dto) async {
    await _appSettingEntity.put(uniqueId, dto.toEntity());
    return AppSettingDto.fromEntity(_appSettingEntity.values.first);
  }
}
