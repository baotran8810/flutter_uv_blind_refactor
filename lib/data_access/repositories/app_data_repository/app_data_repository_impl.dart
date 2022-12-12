import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/app_data_dao/app_data_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/app_data/app_data_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/app_data_repository/app_data_repository.dart';

class AppDataRepositoryImpl implements AppDataRepository {
  final AppDataDao _appDataDao;

  AppDataRepositoryImpl({
    required AppDataDao appDataDao,
  }) : _appDataDao = appDataDao;

  @override
  Future<AppDataDto> getAppData() async {
    return await _appDataDao.getAppData();
  }

  @override
  Future<AppDataDto> saveData({
    bool? isOnboardCompleted,
    DateTime? pollyLastModifiedAt,
    String? signLanguageId,
    bool? hasMigratedFromOldApp,
  }) async {
    final currentAppData = await _appDataDao.getAppData();

    final newAppData = AppDataDto(
      isOnboardCompleted:
          isOnboardCompleted ?? currentAppData.isOnboardCompleted,
      pollyLastModifiedAt:
          pollyLastModifiedAt ?? currentAppData.pollyLastModifiedAt,
      signLanguageId: signLanguageId ?? currentAppData.signLanguageId,
      hasMigratedFromOldApp:
          hasMigratedFromOldApp ?? currentAppData.hasMigratedFromOldApp,
    );

    return await _appDataDao.saveAppData(newAppData);
  }
}
