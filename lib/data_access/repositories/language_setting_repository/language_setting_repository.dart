import 'package:flutter_uv_blind_refactor/data_access/dtos/language/language_dto.dart';

abstract class LanguageSettingRepository {
  Future<void> setLangKey(String langKey);

  /// return `null` if device locale isn't in languageList
  Future<String?> getCurrentLangKey();
}

final List<LanguageDto> kLanguageList = [
  LanguageDto(jpName: '英語', enName: 'English', langKey: '.eng'),
  LanguageDto(jpName: '日本語', enName: 'Japanese', langKey: '.jpn'),
  LanguageDto(jpName: '簡体字', enName: 'Simplified Chinese', langKey: '.chi'),
  LanguageDto(jpName: '繁体字', enName: 'Tradition Chinese', langKey: '.zho'),
  LanguageDto(jpName: '韓国語', enName: 'Korean', langKey: '.kor'),
  LanguageDto(jpName: 'フランス語', enName: 'French', langKey: '.fre'),
  LanguageDto(jpName: 'ドイツ語', enName: 'German', langKey: '.ger'),
  LanguageDto(jpName: 'スペイン語', enName: 'Spanish', langKey: '.spa'),
  LanguageDto(jpName: 'イタリア語', enName: 'Italian', langKey: '.ita'),
  LanguageDto(jpName: 'ポルトガル語', enName: 'Portuguese', langKey: '.por'),
  LanguageDto(jpName: 'ロシア語', enName: 'Russian', langKey: '.rus'),
  LanguageDto(jpName: 'タイ語', enName: 'Thai', langKey: '.tai'),
  LanguageDto(jpName: 'インドネシア語', enName: 'Indonesian', langKey: '.ind'),
  LanguageDto(jpName: 'アラビア語', enName: 'Arabic', langKey: '.ara'),
  LanguageDto(jpName: 'オランダ語', enName: 'Dutch', langKey: '.dut'),
  LanguageDto(jpName: 'インド言語', enName: 'Hindi', langKey: '.hin'),
];
