import 'package:flutter_uv_blind_refactor/data_access/dtos/language/language_dto.dart';

abstract class LanguageSettingController {
  bool get isLoadingLanguageList;
  List<LanguageDto> get languageList;
  void setLanguage(String language);
  String? get currentLanguageCode;
}
