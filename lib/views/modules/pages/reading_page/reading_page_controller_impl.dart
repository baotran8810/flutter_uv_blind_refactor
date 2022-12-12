import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/miscs/debouncer.dart';
import 'package:flutter_uv_blind_refactor/common/utility/miscs/tts_player.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/a11y_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/log_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/dialog_view_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/loading_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/app_setting/app_setting_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/doc_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/app_setting_repository/app_setting_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/language_setting_repository/language_setting_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/scan_code_repository/scan_code_repository.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_life_cycle/app_life_cycle_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/reading_page/reading_page_controller.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadingPageControllerImpl extends AppLifeCycleController
    implements ReadingPageController {
  final SpeakingService _speakingService;
  final ScanCodeRepository _scanCodeRepository;
  final AppSettingRepository _appSettingRepository;
  final LanguageSettingRepository _languageSettingRepository;

  final Debouncer _debouncer = Debouncer();

  DocScanCodeDto docScanCode;
  final String? signLanguageURL;

  ReadingPageControllerImpl({
    required AppSettingRepository appSettingRepository,
    required SpeakingService speakingService,
    required ScanCodeRepository scanCodeRepository,
    required LanguageSettingRepository languageSettingRepository,
    required this.docScanCode,
    required this.signLanguageURL,
  })  : _speakingService = speakingService,
        _scanCodeRepository = scanCodeRepository,
        _appSettingRepository = appSettingRepository,
        _languageSettingRepository = languageSettingRepository;

  late final AppSettingDto _appSettingDto;

  late final String _playerId;

  final RxBool _isLoading = false.obs;
  @override
  bool get isLoading => _isLoading.value;

  final RxBool _isBlindModeOn = false.obs;
  @override
  bool get isBlindModeOn => _isBlindModeOn.value;

  final Rx<TextEditingController> _textControllerTitle =
      Rx(TextEditingController());
  @override
  TextEditingController get textControllerTitle => _textControllerTitle.value;

  Map<String, String> _langKeyWithContentMap = {};

  /// is [_langKeyWithContentMap]'s keys but with right order
  final Rx<List<String>> _langKeyList = Rx([]);
  @override
  List<String> get langKeyList => _langKeyList.value;

  final Rx<String> _selectedLangKey = Rx('');
  @override
  String get selectedLangKey => _selectedLangKey.value;

  final Rx<List<SentenceItem>> _sentenceItemList = Rx([]);
  @override
  List<SentenceItem> get sentenceItemList => _sentenceItemList.value;

  @override
  List<String> get sentenceList => sentenceItemList
      .map((sentenceItem) => sentenceItem.getSentence())
      .toList();

  final Rx<double> _currentVolume = Rx(1);

  @override
  double get currentVolume => _currentVolume.value;

  final Rx<double> _currentSpeed = Rx(1);
  @override
  double get currentSpeed => _currentSpeed.value;

  final Rx<bool> _isCompleted = Rx(false);
  @override
  bool get isCompleted => _isCompleted.value;

  final Rx<bool> _isPlaying = Rx(false);
  @override
  bool get isPlaying => _isPlaying.value;

  final Rx<int> _currentPlayerIndex = Rx(-1);
  @override
  int get currentPlayerIndex => _currentPlayerIndex.value;

  final Rx<bool> _isPlayingAutoplayBlindMode = Rx(false);
  @override
  bool get isPlayingAutoplayBlindMode => _isPlayingAutoplayBlindMode.value;

  final Rx<String?> _originalUrl = "".obs;
  @override
  String? get originalUrl => _originalUrl.value;

  final Rx<bool> _isBookmark = false.obs;
  @override
  bool get isBookmark => _isBookmark.value;

  final Rx<AppVoice> _appVoiceReadingPage = AppVoice.device.obs;
  @override
  AppVoice get appVoiceReadingPage => _appVoiceReadingPage.value;

  List<GlobalKey<State<StatefulWidget>>> _sentenceWidgetKeys = [];
  @override
  List<GlobalKey<State<StatefulWidget>>> get sentenceWidgetKeys =>
      _sentenceWidgetKeys;

  StreamSubscription? _streamSubCurrentVolume;
  StreamSubscription? _streamSubCurrentSpeed;
  StreamSubscription? _streamSubIsPlaying;
  StreamSubscription? _streamSubCurrentIndex;
  StreamSubscription? _streamSubPlayerState;

  @override
  Future<void> onInit() async {
    super.onInit();

    _appSettingDto = await _appSettingRepository.getAppSetting();

    await _fetchBlindModeStatus();

    if (isBlindModeOn && _appSettingDto.isAutoplayReading) {
      // Temp disable initial focus VO/Talkback.
      // Should call this ASAP on init.
      _isPlayingAutoplayBlindMode.value = true;
    }

    _isLoading.value = true;
    docScanCode = await _scanCodeRepository.syncDocScanCode(docScanCode);
    _isLoading.value = false;

    _isBookmark.value = docScanCode.isBookmark;

    _currentSpeed.value = _appSettingDto.audioReadingSpeed;

    _appVoiceReadingPage.value = _appSettingDto.appVoiceReadingPage;

    _textControllerTitle.value.text = docScanCode.name;
    _langKeyWithContentMap = docScanCode.langKeyWithContent;

    if (docScanCode.codeInfo?.originalUrl != null) {
      _originalUrl.value = docScanCode.codeInfo!.originalUrl;
    }

    await _setLangKeyList(_langKeyWithContentMap);

    await initOrSwitchLanguage(
      langKeyList.first,
      isInit: true,
    );
    _isPlayingAutoplayBlindMode.value = false;
  }

  @override
  void onClose() {
    _streamSubCurrentVolume?.cancel();
    _streamSubCurrentSpeed?.cancel();
    _streamSubIsPlaying?.cancel();
    _streamSubCurrentIndex?.cancel();
    _streamSubPlayerState?.cancel();

    _speakingService.disposePlayer(_playerId);

    super.onClose();
  }

  @override
  void onAccessibilityChange() {
    _fetchBlindModeStatus();
  }

  Future<void> _fetchBlindModeStatus() async {
    try {
      _isBlindModeOn.value = await A11yUtils.isBlindModeOn();
      initOrSwitchLanguage(_selectedLangKey.value, isInit: false);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  /// Set _langKeyList, then bring settingLangKey to first if possible
  Future<void> _setLangKeyList(
    Map<String, String> langKeyWithContentMap,
  ) async {
    // Set langKeyList
    _langKeyList.value = langKeyWithContentMap.keys.toList();

    // Find langKey
    final String? settingLangKey =
        await _languageSettingRepository.getCurrentLangKey();

    if (settingLangKey == null) {
      return;
    }

    final foundLangKey = langKeyList.firstWhereOrNull(
      (langKey) => langKey == settingLangKey,
    );

    if (foundLangKey == null) {
      return;
    }

    // Bring foundLangKey to first
    _langKeyList.value.remove(foundLangKey);
    _langKeyList.value.insert(0, foundLangKey);

    _langKeyList.refresh();
  }

  /// set [_selectedLangKey] & [_sentenceItemList]
  void _setLanguage(String langKey) {
    _selectedLangKey.value = langKey;
    final selectedContent = _langKeyWithContentMap[selectedLangKey] ?? '';
    _setSentenceItemList(selectedContent);
  }

  void _setSentenceItemList(String content) {
    _sentenceItemList.value = [];
    final regexp = RegExp(
      r'(.+?)([.]\s+|(\r\n)+|\n+|$|[。]\s*)',
      multiLine: true,
    );
    final matchList = regexp.allMatches(content).toList();
    for (final match in matchList) {
      final String sentenceContent = match.group(1) ?? '';
      final String sentenceSeparator = match.group(2) ?? '';
      _sentenceItemList.value.add(
        SentenceItem(
          content: sentenceContent,
          separator: sentenceSeparator,
        ),
      );
    }
    _sentenceWidgetKeys =
        List.generate(_sentenceItemList.value.length, (i) => GlobalKey());
    _sentenceItemList.refresh();
  }

  @override
  Future<void> initOrSwitchLanguage(
    String langKey, {
    bool isInit = false,
  }) async {
    await LoadingViewUtils.showLoading();

    _setLanguage(langKey);

    if (isInit) {
      // First time calling `switchLanguage`
      _playerId = await _speakingService.initPlayer();
    } else {
      // Not the first time calling `switchLanguage`
      await _speakingService.stop(_playerId);
    }

    try {
      await _speakingService.setSource(
        playerId: _playerId,
        speakItemList: sentenceList
            .map((sentence) => SpeakItem(text: sentence, langKey: langKey))
            .toList(),
        appVoiceReadingPage: _appVoiceReadingPage.value,
      );
    } on UnsupportedLanguageException catch (e) {
      await LoadingViewUtils.hideLoading();
      LogUtils.iNoST('${e.langTag} is not supported.');

      DialogViewUtils.showAlertDialog(
        messageText: tra(LocaleKeys.txt_unSupportLanguageAlert),
      );
      return;
    }

    await LoadingViewUtils.hideLoading();

    await setSpeed(currentSpeed);

    // == Stream subscriptions
    await _streamSubCurrentVolume?.cancel();
    _streamSubCurrentVolume =
        _speakingService.getStreamVolume(_playerId).listen((volume) {
      _currentVolume.value = volume;
    });

    await _streamSubCurrentSpeed?.cancel();
    _streamSubCurrentSpeed =
        _speakingService.getStreamSpeed(_playerId).listen((speed) {
      _currentSpeed.value = speed;
    });

    await _streamSubIsPlaying?.cancel();
    _streamSubIsPlaying =
        _speakingService.getStreamIsPlaying(_playerId).listen((isPlaying) {
      _isPlaying.value = isPlaying;
    });

    await _streamSubCurrentIndex?.cancel();
    _streamSubCurrentIndex =
        _speakingService.getStreamCurrentIndex(_playerId).listen((index) {
      _currentPlayerIndex.value = index ?? -1;
      _autoScroll(_currentPlayerIndex.value);
    });

    await _streamSubPlayerState?.cancel();
    _streamSubPlayerState =
        _speakingService.getStreamState(_playerId).listen((playerState) {
      _isCompleted.value = playerState == ProcessingState.completed;
    });

    // Have signLanguageUrl => Open sign language url on launch
    if (isInit &&
        _appSettingDto.signLanguage &&
        signLanguageURL != null &&
        await canLaunch(signLanguageURL!)) {
      launch(signLanguageURL!);
    }
    // Autoplay in blind mode
    else if (isInit && isBlindModeOn && _appSettingDto.isAutoplayReading) {
      // On iOS, wait for the a11y focus to focus first
      if (Platform.isIOS) {
        await Future.delayed(Duration(milliseconds: 1500));
        A11yUtils.cancelSpeak();
      } else if (Platform.isAndroid) {
        await Future.delayed(Duration(milliseconds: 1000));
      }

      await _speakingService.play(_playerId);
    }
    // Play normally
    else if (!isBlindModeOn) {
      await _speakingService.play(_playerId);
    }
  }

  @override
  void onAppPause() {
    if (_speakingService.getIsPlaying(_playerId)) {
      _speakingService.togglePlayOrPause(_playerId);
    }
  }

  @override
  void onAppResume() {
    if (_speakingService.getIsPlaying(_playerId)) {
      _speakingService.togglePlayOrPause(_playerId);
    }
  }

  @override
  Future<void> copyContent() async {
    DialogViewUtils.showAlertDialog(
      messageText: tra(LocaleKeys.txt_copyContentConfirm),
    );

    Clipboard.setData(
      ClipboardData(text: sentenceList.join()),
    );
  }

  @override
  Future<void> deleteCode() async {
    final isConfirmed = await DialogViewUtils.showConfirmDialog(
      titleText: tra(LocaleKeys.txt_delete),
      messageText: tra(LocaleKeys.txt_deleteFileConfirm),
    );

    if (!isConfirmed) {
      return;
    }

    _scanCodeRepository.deleteScanCode(docScanCode.id);
    Get.back();
  }

  @override
  void changeTitle() {
    _scanCodeRepository.updateName(docScanCode.id, textControllerTitle.text);
  }

  @override
  Future sendEmail() async {
    final isConfirmed = await DialogViewUtils.showConfirmDialog(
      titleText: tra(LocaleKeys.txt_confirmSendEmailTitle),
      messageText: tra(LocaleKeys.txt_confirmSendEmailContent),
    );

    if (!isConfirmed) {
      return;
    }

    final MailOptions mailOptions = MailOptions(
      subject: "Uni-Voice Code Data",
      body: sentenceList.join(),
    );
    await FlutterMailer.send(mailOptions);
  }

  @override
  void playFromStart() {
    _speakingService.playFromStart(_playerId);
  }

  @override
  void seekToPrevious() {
    _speakingService.seekToPrevious(_playerId);
  }

  @override
  void seekToNext() {
    _speakingService.seekToNext(_playerId);
  }

  @override
  void togglePlayOrPause() {
    _speakingService.togglePlayOrPause(_playerId);
  }

  @override
  Future<void> setSpeed(double speed) async {
    _speakingService.setSpeed(_playerId, speed);
    _debouncer.run(
      () => _appSettingRepository.saveSetting(audioReadingSpeed: speed),
    );
  }

  @override
  void toggleMute() {
    _speakingService.toggleMute(_playerId);
  }

  void _autoScroll(int index) {
    if (_sentenceWidgetKeys[index].currentContext != null) {
      Scrollable.ensureVisible(
        _sentenceWidgetKeys[index].currentContext!,
        alignment: 0.3,
        duration: Duration(milliseconds: 500),
      );
    }
  }

  @override
  Future<void> setBookmark() async {
    await _scanCodeRepository.updateIsBookmark(docScanCode.id);
    _isBookmark.value = !_isBookmark.value;
  }

  @override
  Future<void> setAppVoice(AppVoice value) async {
    await _appSettingRepository.saveSetting(appVoiceReadingPage: value);
    _appVoiceReadingPage.value = value;

    initOrSwitchLanguage(_selectedLangKey.value, isInit: false);
  }
}
