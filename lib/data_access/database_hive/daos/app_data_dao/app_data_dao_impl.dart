import 'package:flutter_uv_blind_refactor/data_access/database_hive/app_hive.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/app_data_dao/app_data_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/app_data/app_data_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/app_data/app_data_dto.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AppDataDaoImpl implements AppDataDao {
  final Box<AppDataEntity> _appDataEntity;

  AppDataDaoImpl()
      : _appDataEntity = Get.find<AppHive>().getBox<AppDataEntity>();

  @override
  Future<AppDataDto> getAppData() async {
    if (_appDataEntity.values.isEmpty) {
      return await saveAppData(AppDataDto.initDefault());
    }

    return AppDataDto.fromEntity(_appDataEntity.values.first);
  }

  @override
  Future<AppDataDto> saveAppData(AppDataDto dto) async {
    await _appDataEntity.put(uniqueId, dto.toEntity());
    return AppDataDto.fromEntity(_appDataEntity.values.first);
  }
}
