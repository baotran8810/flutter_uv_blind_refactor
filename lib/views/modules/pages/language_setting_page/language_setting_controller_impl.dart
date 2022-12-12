import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/language/language_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/language_setting_repository/language_setting_repository.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/language_setting_page/language_setting_controller.dart';
import 'package:get/get.dart';

class LanguageSettingControllerImpl extends GetxController
    implements LanguageSettingController {
  final LanguageSettingRepository _languageSettingRepository;

  LanguageSettingControllerImpl({
    required LanguageSettingRepository languageSettingRepository,
  }) : _languageSettingRepository = languageSettingRepository;

  final Rx<bool> _isLoading = false.obs;

  @override
  bool get isLoadingLanguageList => _isLoading.value;

  final Rx<List<LanguageDto>> _languageList = Rx([]);

  @override
  List<LanguageDto> get languageList => _languageList.value;

  final Rx<String?> _currentLanguage = Rx(null);

  @override
  String? get currentLanguageCode => _currentLanguage.value;

  @override
  Future<void> onInit() async {
    super.onInit();

    await _getCurrentLanguage();
    await _getLanguageList();
  }

  Future<void> _getLanguageList() async {
    try {
      _isLoading.value = true;
      final List<LanguageDto> languages = kLanguageList;

      _languageList.value = List.from(languages);
    } catch (e) {
      Get.snackbar(tra(LocaleKeys.txt_error),
          tra(LocaleKeys.txt_canNotGetDataFromServer),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _getCurrentLanguage() async {
    _currentLanguage.value =
        await _languageSettingRepository.getCurrentLangKey();
  }

  @override
  void setLanguage(String language) {
    _languageSettingRepository.setLangKey(language);
    _currentLanguage.value = language;
  }
}
