import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/miscs/tts_player.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/a11y_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/datetime_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/dialog_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/doc_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/language_setting_repository/language_setting_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/scan_code_repository/scan_code_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/voice_input_service/voice_input_service.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/voice_input_result_page/voice_input_result_page_controller.dart';
import 'package:get/get.dart';

class VoiceInputResultPageControllerImpl extends GetxController
    implements VoiceInputResultPageController {
  final ScanCodeRepository _scanCodeRepository;
  final SpeakingService _speakingService;
  final LanguageSettingRepository _languageSettingRepository;

  final VoiceDecodedResult voiceDecodedResult;

  VoiceInputResultPageControllerImpl({
    required ScanCodeRepository scanCodeRepository,
    required SpeakingService speakingService,
    required LanguageSettingRepository languageSettingRepository,
    required this.voiceDecodedResult,
  })  : _scanCodeRepository = scanCodeRepository,
        _speakingService = speakingService,
        _languageSettingRepository = languageSettingRepository;

  final Rx<List<ScanCodeDto>> _scanCodeList = Rx([]);
  @override
  List<ScanCodeDto> get scanCodeList => _scanCodeList.value;

  int _currentReadingFileIndex = 0;

  @override
  Future<void> onInit() async {
    super.onInit();

    _fetchScanCodeList();

    // Workaround to wait for the title to complete reading
    final isBlindModeOn = await A11yUtils.isBlindModeOn();
    if (isBlindModeOn) {
      await Future.delayed(Duration(milliseconds: 2000));
    }

    await readNextFile();
  }

  @override
  Future<void> onClose() async {
    _speakingService.pauseCommonPlayer();
    super.onClose();
  }

  void _fetchScanCodeList() {
    final List<ScanCodeDto> allScanCodeList =
        _scanCodeRepository.getAllScanCode();
    _scanCodeList.value = _filterScanCodeListBySearchCriteria(allScanCodeList);
  }

  // Consider bringing this into ScanDecodeRepository layer
  List<ScanCodeDto> _filterScanCodeListBySearchCriteria(
    List<ScanCodeDto> scanCodeList,
  ) {
    final searchCriteria = voiceDecodedResult.searchCriteria;

    final List<String> resultIds = List.from(
      scanCodeList.map((scanCode) => scanCode.id),
    );
    List<String> resultIdsByDateRange = [...resultIds];
    List<String> resultIdsByKeyword = [...resultIds];

    final dateRange = searchCriteria.dateRange;
    if (dateRange != null) {
      resultIdsByDateRange = scanCodeList
          .where(
            (scanCode) =>
                scanCode.createdDate.compareTo(dateRange.fromDate) >= 0 &&
                scanCode.createdDate.compareTo(dateRange.toDate) <= 0,
          )
          .map((scanCode) => scanCode.id)
          .toList();
    }

    final keyword = searchCriteria.keyword;
    if (keyword != null) {
      resultIdsByKeyword = scanCodeList
          .where((scanCode) => scanCode.getSearchContent().contains(keyword))
          .map((scanCode) => scanCode.id)
          .toList();
    }

    // Intersect
    resultIds.removeWhere((id) => !resultIdsByDateRange.contains(id));
    resultIds.removeWhere((id) => !resultIdsByKeyword.contains(id));

    return scanCodeList
        .where((scanCode) => resultIds.contains(scanCode.id))
        .toList();
  }

  @override
  Future<void> readNextFile() async {
    if (_currentReadingFileIndex >= scanCodeList.length &&
        scanCodeList.isNotEmpty) {
      _speakingService.speakSentences([
        SpeakItem(
          text: tra(LocaleKeys.semTxt_readingAllFileDone),
        )
      ]);
      return;
    }

    final List<SpeakItem> speakItemList = [];
    if (_currentReadingFileIndex == 0) {
      speakItemList.add(
        SpeakItem(text: craftSearchResultOutput()),
      );
    }

    if (voiceDecodedResult.action == VoiceAction.reading) {
      final fileOutput = await _craftFileInfoOutput(
        fileIndex: _currentReadingFileIndex,
        scanCodeList: scanCodeList,
      );
      speakItemList.addAll(fileOutput);
    }

    try {
      // Don't await this
      _speakingService.speakSentences(speakItemList);
    } on UnsupportedLanguageException {
      DialogViewUtils.showAlertDialog(
        messageText: tra(LocaleKeys.txt_unSupportLanguageAlert),
      );
    }

    _currentReadingFileIndex++;
  }

  @override
  String craftSearchResultOutput() {
    if (scanCodeList.isEmpty) {
      return tra(
        LocaleKeys.txt_searchResultNotFoundWA,
        namedArgs: {
          'speech': voiceDecodedResult.getSpeechStr(),
        },
      );
    }

    final keyword = voiceDecodedResult.searchCriteria.keyword;
    final dateRange = voiceDecodedResult.searchCriteria.dateRange;
    final fileCountStr = scanCodeList.length.toString();

    String? result;

    if (dateRange != null && keyword != null) {
      result = tra(
        LocaleKeys.txt_searchResultDateKeywordWA,
        namedArgs: {
          'dateString': dateRange.originalDateRangeInput,
          'keyword': keyword,
          'fileCount': fileCountStr,
        },
      );
    } else if (dateRange != null) {
      result = tra(
        LocaleKeys.txt_searchResultDateWA,
        namedArgs: {
          'dateString': dateRange.originalDateRangeInput,
          'fileCount': fileCountStr,
        },
      );
    } else if (keyword != null) {
      result = tra(
        LocaleKeys.txt_searchResultKeywordWA,
        namedArgs: {
          'keyword': keyword,
          'fileCount': fileCountStr,
        },
      );
    } else {
      result = tra(
        LocaleKeys.txt_searchResultWA,
        namedArgs: {
          'fileCount': fileCountStr,
        },
      );
    }

    return result;
  }

  Future<List<SpeakItem>> _craftFileInfoOutput({
    required int fileIndex,
    required List<ScanCodeDto> scanCodeList,
  }) async {
    if (fileIndex >= scanCodeList.length) {
      return [];
    }

    final currentFile = scanCodeList[fileIndex];
    final fileDateStr = DateTimeUtils.formatDateTime(currentFile.createdDate);
    final String fileContent = currentFile.name;

    final List<SpeakItem> result = [];

    // If is first file
    if (fileIndex == 0) {
      result.add(SpeakItem(
        text: tra(
          LocaleKeys.semTxt_readingFirstSearchResultWA,
          namedArgs: {
            "createdDate": fileDateStr,
            "title": fileContent,
          },
        ),
      ));
    }
    // If is final file
    else if (fileIndex == scanCodeList.length - 1) {
      result.add(SpeakItem(
        text: tra(
          LocaleKeys.semTxt_readingFinalSearchResultWA,
          namedArgs: {
            "createdDate": fileDateStr,
            "title": fileContent,
          },
        ),
      ));
    }
    // If is neither first nor final file
    else {
      result.add(SpeakItem(
        text: tra(
          LocaleKeys.semTxt_readingNotFinalSearchResultWA,
          namedArgs: {
            "createdDate": fileDateStr,
            "title": fileContent,
          },
        ),
      ));
    }

    if (currentFile is DocScanCodeDto) {
      final String langKey = await _getLangKey(currentFile.langKeyWithContent);

      result.addAll(
        [
          ConstScript.kSilence,
          tra(LocaleKeys.semTxt_readingSearchResultContent),
          ConstScript.kSilence,
          ConstScript.kSilence,
        ].map((text) => SpeakItem(text: text)).toList(),
      );

      result.addAll([
        SpeakItem(
          text: currentFile.langKeyWithContent[langKey] ?? "",
          langKey: langKey,
        ),
      ]);
    }
    return result;
  }

  /// Get langKey based on setting language
  Future<String> _getLangKey(Map<String, String> langKeyWithContentMap) async {
    final String? settingLangKey =
        await _languageSettingRepository.getCurrentLangKey();

    final List<String> _langKeyList = langKeyWithContentMap.keys.toList();

    if (settingLangKey == null) {
      return _langKeyList.first;
    }

    final foundLangKey = _langKeyList.firstWhereOrNull(
      (langKey) => langKey == settingLangKey,
    );

    if (foundLangKey == null) {
      return _langKeyList.first;
    }

    return foundLangKey;
  }
}
