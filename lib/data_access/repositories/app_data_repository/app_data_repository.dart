import 'package:flutter_uv_blind_refactor/data_access/dtos/app_data/app_data_dto.dart';

abstract class AppDataRepository {
  Future<AppDataDto> getAppData();

  Future<AppDataDto> saveData({
    bool? isOnboardCompleted,
    DateTime? pollyLastModifiedAt,
    bool? hasMigratedFromOldApp,
  });
}
