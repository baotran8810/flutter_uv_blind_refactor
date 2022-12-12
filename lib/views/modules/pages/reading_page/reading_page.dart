import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/a11y_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/linkify_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/doc_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/semantics_manage_controller/semantics_manage_controller.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/setting_controller/setting_controller.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/reading_page/reading_page_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/reading_page/reading_page_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_button_new.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_dropdown.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_switcher.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

part 'widgets/read_section.dart';
part 'widgets/reading_title_actions.dart';

Map<String, String> _langKeyWithDisplayNameMap = {
  '.jpn': '日本語',
  '.eng': 'English',
  '.chi': '簡体字',
  '.kor': '한국어',
  '.zho': '繁体字',
  '.vie': 'Tiếng Việt',
  '.fre': 'Français',
  '.ger': "Deutsche",
  '.spa': 'Español',
  '.ita': 'Italiano',
  '.por': 'Português',
  '.rus': 'Pусский',
  '.tai': 'ไทย',
  '.ind': 'Bahasa Indonesia',
  '.ara': 'عربى',
  '.dut': 'Nederlands',
  '.hin': 'हिंदी',
  '.tgl': "Tagalog",
  '.may': 'Bahasa Melayu',
};

Map<String, String> _langKeyWithLocalizedNameMapJpn = {
  '.eng': '英語',
  '.jpn': '日本語',
  '.chi': '簡体字',
  '.kor': '韓国語',
  '.zho': '繁体字',
  '.vie': 'ベトナム語',
  '.fre': 'フランス語',
  '.ger': "ドイツ語",
  '.spa': 'スペイン語',
  '.ita': 'イタリア語',
  '.por': 'ポルトガル語',
  '.rus': 'ロシア語',
  '.tai': 'タイ語',
  '.ind': 'インドネシア語',
  '.ara': 'アラビア語',
  '.dut': 'オランダ語',
  '.hin': 'ヒンディー語',
  '.tgl': "タガログ語",
  '.may': 'マレー語',
};

Map<String, String> _langKeyWithLocalizedNameMapEng = {
  '.eng': 'English',
  '.jpn': 'Japanese',
  '.chi': 'Simplified Chinese',
  '.kor': 'Korean',
  '.zho': 'Traditional Chinese',
  '.vie': 'Vietnamese',
  '.fre': 'French',
  '.ger': "German",
  '.spa': 'Spanish',
  '.ita': 'Italian',
  '.por': 'Portuguese',
  '.rus': 'Russian',
  '.tai': 'Thai',
  '.ind': 'Indonesian',
  '.ara': 'Arabic',
  '.dut': 'Dutch',
  '.hin': 'Hindi',
  '.tgl': "Tagalog",
  '.may': 'Malay',
};

String _getLocalizedLangName(String _langKey) {
  final foundLang = LocalizationUtils.getLanguage();
  switch (foundLang) {
    case SupportedLanguage.en:
      return _langKeyWithLocalizedNameMapEng[_langKey] ?? "";
    case SupportedLanguage.ja:
      return _langKeyWithLocalizedNameMapJpn[_langKey] ?? "";
  }
}

class ReadingPageArguments {
  final DocScanCodeDto docScanCode;
  final String? signLanguageURL;

  const ReadingPageArguments({
    required this.docScanCode,
    this.signLanguageURL,
  });
}

class ReadingPage extends AppGetView<ReadingPageController> {
  final ReadingPageArguments arguments;
  final SettingController _settingController;

  ReadingPage({
    Key? key,
    required this.arguments,
  })  : _settingController = Get.find(),
        super(
          key: key,
          initialController: ReadingPageControllerImpl(
            speakingService: Get.find(),
            scanCodeRepository: Get.find(),
            docScanCode: arguments.docScanCode,
            signLanguageURL: arguments.signLanguageURL,
            appSettingRepository: Get.find(),
            languageSettingRepository: Get.find(),
          ),
        );

  @override
  Widget build(BuildContext context, controller) {
    return BaseLayout(
      header: _buildHeader(controller),
      body: _buildBody(context, controller),
    );
  }

  Widget _buildHeader(ReadingPageController controller) {
    return Obx(() {
      final isBlindMode = controller.isBlindModeOn;
      final isBookmark = controller.isBookmark;

      return AppHeader(
        titleText: tra(LocaleKeys.titlePage_readingPage),
        title: !isBlindMode ? null : _buildHeaderTitleBlindMode(controller),
        semanticsTitle: tra(LocaleKeys.semTitlePage_readingPage),
        bottomChild: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !isBlindMode
                ? SizedBox()
                : Row(
                    children: [
                      Obx(
                        () {
                          final isAutoplayReading = _settingController
                                  .appSetting?.isAutoplayReading ??
                              false;

                          return _AutoplaySwitcher(
                            isAutoplayReading: isAutoplayReading,
                            onChangedAutoplay: (newValue) {
                              _settingController.setIsAutoplayReading(newValue);
                            },
                          );
                        },
                      ),
                      _buidDropDownVoiceSetting(controller),
                      SizedBox(
                        width: 4,
                      ),
                    ],
                  ),
            BottomActions(
              actionInfoList: [
                BottomActionInfo(
                  imageSize: 40,
                  color: Colors.transparent,
                  semanticText: tra(LocaleKeys.btn_copyContent),
                  onPressed: () {
                    controller.copyContent();
                  },
                  iconImgAsset: AppAssets.iconCopy,
                ),
                BottomActionInfo(
                  imageSize: 40,
                  color: Colors.transparent,
                  semanticText: tra(LocaleKeys.btn_sendEmail),
                  onPressed: () {
                    controller.sendEmail();
                  },
                  iconImgAsset: AppAssets.iconSendEmail,
                ),
                BottomActionInfo(
                  semanticText: !isBookmark
                      ? tra(LocaleKeys.semBtn_fileBookmark)
                      : tra(LocaleKeys.semBtn_fileUnbookmark),
                  color: Color(0xFFFD9D24),
                  iconImgAsset:
                      !isBookmark ? AppAssets.iconStar : AppAssets.iconUnStar,
                  onPressed: () {
                    controller.setBookmark();
                  },
                ),
                BottomActionInfo(
                  imageSize: 40,
                  color: Colors.transparent,
                  semanticText: tra(LocaleKeys.semBtn_fileDelete),
                  onPressed: () {
                    controller.deleteCode();
                  },
                  iconImgAsset: AppAssets.iconDelete,
                ),
              ],
            )
          ],
        ),
        helpScript: tra(LocaleKeys.helpScript_read),
      );
    });
  }

  Widget _buildHeaderTitleBlindMode(ReadingPageController controller) {
    return Obx(() {
      final isPlaying = controller.isPlaying;
      final isCompleted = controller.isCompleted;
      final isPlayingAutoplay = controller.isPlayingAutoplayBlindMode;

      return _TitleActions(
        isPlaying: isPlaying,
        isCompleted: isCompleted,
        isPlayingAutoplay: isPlayingAutoplay,
        onPressedPlayPause: () async {
          A11yUtils.cancelSpeak();

          if (isCompleted) {
            controller.playFromStart();
          } else {
            controller.togglePlayOrPause();
          }
        },
      );
    });
  }

  Widget _buildBody(BuildContext context, ReadingPageController controller) {
    return Obx(
      () {
        final isLoading = controller.isLoading;
        final langCount = controller.langKeyList.length;

        return isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  if (langCount > 1) ...[
                    SizedBox(height: AppDimens.paddingNormal),
                    _buildLanguageButtons(controller),
                  ],
                  SizedBox(height: AppDimens.paddingNormal),
                  Expanded(
                    child: _ReadSection(
                      controller: controller,
                    ),
                  ),
                ],
              );
      },
    );
  }

  Widget _buildLanguageButtons(ReadingPageController controller) {
    return Obx(
      () {
        final langKeyList = controller.langKeyList;
        final selectedLangKey = controller.selectedLangKey;

        return Container(
          height: 46,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.paddingNormal,
            ),
            scrollDirection: Axis.horizontal,
            children: [
              ...langKeyList.map((_langKey) {
                final isLastItem =
                    langKeyList.indexOf(_langKey) == langKeyList.length - 1;

                return Container(
                  width: 110,
                  margin: EdgeInsets.only(right: isLastItem ? 0 : 10),
                  child: AppButtonNew(
                    height: 46,
                    onPressed: () {
                      controller.initOrSwitchLanguage(_langKey);
                    },
                    // TODO refactor AppButtonNew's args & use labelList instead
                    suffixLabelList: _getBtnLabelList(_langKey),
                    btnColor: selectedLangKey == _langKey
                        ? Color(0xffA21942)
                        : Color(0xffd67895),
                    textColor: Colors.white,
                    child: Text(
                      _langKeyWithDisplayNameMap[_langKey] ?? _langKey,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  List<String> _getBtnLabelList(String langKey) {
    final originalLang = _langKeyWithDisplayNameMap[langKey] ?? langKey;

    final readAloudLangStr = tra(
      LocaleKeys.semTxt_readAloudLangWA,
      namedArgs: {
        "localizedLang": _getLocalizedLangName(langKey),
      },
    );

    switch (LocalizationUtils.getLanguage()) {
      case SupportedLanguage.en:
        // Example: Read aloud with Japanese, 日本語
        return [
          readAloudLangStr,
          if (langKey != '.eng') ...[
            ConstScript.kSilence,
            originalLang,
          ],
        ];
      case SupportedLanguage.ja:
        // Example: English, 英語で読み上げる
        return [
          if (langKey != '.jpn') ...[
            originalLang,
            ConstScript.kSilence,
          ],
          readAloudLangStr,
        ];
    }
  }
}

Widget _buidDropDownVoiceSetting(ReadingPageController controller) {
  return Obx(
    () {
      final AppVoice currentAppVoiceReadingPage =
          controller.appVoiceReadingPage;
      return Row(
        children: [
          AppDropdown(
            semanticsLabel: tra(LocaleKeys.semTxt_settingAppVoiceReadingScreen),
            currentValue: currentAppVoiceReadingPage,
            icon: Image.asset(AppAssets.iconVoiceSetting),
            valueList: AppVoice.values,
            getDisplayText: (value) {
              print(AppVoice.values);
              return value == AppVoice.univoice
                  ? tra(LocaleKeys.txt_appVoiceUnivoice)
                  : tra(LocaleKeys.txt_appVoiceDevice);
            },
            onChanged: (value) {
              controller.setAppVoice(value! as AppVoice);
            },
            isExpanded: true,
            showCheck: true,
            buttonHeight: 40,
            buttonWidth: 40,
          )
        ],
      );
    },
  );
}
