import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/language_setting_dao/language_setting_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/language_setting_repository/language_setting_repository.dart';

class LanguageSettingRepositoryImpl implements LanguageSettingRepository {
  final LanguageSettingDao _languageSettingDao;

  LanguageSettingRepositoryImpl({
    required LanguageSettingDao languageSettingDao,
  }) : _languageSettingDao = languageSettingDao;

  @override
  Future<void> setLangKey(String langKey) async {
    await _languageSettingDao.setLangKey(langKey);
  }

  /// return `null` if device locale isn't in languageList
  @override
  Future<String?> getCurrentLangKey() async {
    return await _languageSettingDao.getCurrentLangKey();
  }
}
