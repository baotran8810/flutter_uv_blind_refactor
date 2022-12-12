import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:get/get.dart';

String tra(
  String key, {
  List<String>? args,
  Map<String, String>? namedArgs,
  String? gender,
}) {
  return tr(key, args: args, namedArgs: namedArgs, gender: gender);
}

class LocalizationUtils {
  static BuildContext _getContext() {
    final context = Get.context;

    if (context == null) {
      throw Exception('CUSTOM: Cannot find context');
    }

    return context;
  }

  static Locale getCurrentLocale() {
    return _getContext().locale;
  }

  static SupportedLanguage getLanguage() {
    for (final supportedLang in SupportedLanguage.values) {
      if (supportedLang.getLocale() == getCurrentLocale()) {
        return supportedLang;
      }
    }

    throw Exception(
      'CUSTOM: cannot find language of ${getCurrentLocale().languageCode}',
    );
  }

  static void switchLanguage(SupportedLanguage language) {
    final Locale foundLocale = language.getLocale();

    // For "easy_localization"
    _getContext().setLocale(foundLocale);
    // For "get"
    Get.updateLocale(foundLocale);
  }

  /// Get langKey based on current locale
  static String? getCurrentLangKey() {
    final currentLocale = getCurrentLocale();
    for (final entry in _languageKeyWithLocale.entries) {
      final entryLangKey = entry.key;
      final entryLocale = entry.value;

      if (currentLocale.languageCode == entryLocale.languageCode &&
          currentLocale.countryCode == entryLocale.countryCode) {
        return entryLangKey;
      }

      if (currentLocale.languageCode == entryLocale.languageCode) {
        return entryLangKey;
      }
    }

    // Cannot find langKey of current locale
    return null;
  }

  static Locale getLocaleByLangKey(String langKey) {
    final foundLocale = _languageKeyWithLocale[langKey];

    if (foundLocale != null) {
      return foundLocale;
    }

    throw Exception(
      'CUSTOM: Cannot find locale inside $_languageKeyWithLocale',
    );
  }

  static String getLangKeyWithFallback(String? langKey) {
    return langKey ?? LocalizationUtils.getCurrentLangKey() ?? '.jpn';
  }
}

// Make the value of this List<Locale> instead
const Map<String, Locale> _languageKeyWithLocale = {
  '.jpn': Locale('ja', 'JP'),
  '.eng': Locale('en', 'US'),
  '.chi': Locale('zh', 'CN'),
  '.kor': Locale('ko', 'KR'),
  '.zho': Locale('zh', 'TW'),
  '.vie': Locale('vi', 'VN'),
  '.fre': Locale('fr', 'FR'),
  '.ger': Locale('de', 'DE'),
  '.spa': Locale('es', 'ES'),
  '.ita': Locale('it', 'IT'),
  '.por': Locale('pt', 'PT'),
  '.rus': Locale('ru', 'RU'),
  '.tai': Locale('th', 'TH'),
  '.ind': Locale('id', 'ID'),
  '.ara': Locale('ar', 'SA'),
  '.dut': Locale('nl', 'NL'),
  '.hin': Locale('hi', 'IN'),
  '.tgl': Locale('fil', 'PH'),
  '.may': Locale('ms', 'MY'),
};
