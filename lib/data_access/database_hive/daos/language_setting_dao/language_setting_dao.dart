abstract class LanguageSettingDao {
  Future<String?> getCurrentLangKey();

  Future<void> setLangKey(String? languageKey);
}
