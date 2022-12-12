import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/app_hive.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/daos/language_setting_dao/language_setting_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/language_setting/language_setting_entity.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class LanguageSettingDaoImpl implements LanguageSettingDao {
  final Box<LanguageSettingEntity> _languageSettingBox;

  LanguageSettingDaoImpl()
      : _languageSettingBox =
            Get.find<AppHive>().getBox<LanguageSettingEntity>();

  @override
  Future<String?> getCurrentLangKey() async {
    final LanguageSettingEntity? languageSettingEntity =
        _languageSettingBox.get(uniqueId);

    // If open app for the first time
    if (languageSettingEntity == null) {
      // Get langKey of device as default
      final langKey = LocalizationUtils.getCurrentLangKey();

      await setLangKey(langKey);
    }

    final newEntity = _languageSettingBox.get(uniqueId)!;
    return newEntity.currentLangKey;
  }

  @override
  Future<void> setLangKey(String? langKey) async {
    await _languageSettingBox.put(
      uniqueId,
      LanguageSettingEntity(currentLangKey: langKey),
    );
  }
}
