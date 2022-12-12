import 'package:flutter_uv_blind_refactor/data_access/dtos/app_data/app_data_dto.dart';

abstract class AppDataDao {
  Future<AppDataDto> getAppData();
  Future<AppDataDto> saveAppData(AppDataDto dto);
}
