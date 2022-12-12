import 'dart:io';

import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/a11y_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/hardware_service/hardware_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/voice_input_service/voice_input_service.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/voice_input_page/voice_input_page_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/voice_input_result_page/voice_input_result_page.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:speech_to_text/speech_to_text.dart';

const String _STT_STATUS_LISTENING = 'listening';
const String _STT_STATUS_NOTLISTENING = 'notListening';

class VoiceInputPageControllerImpl extends GetxController
    implements VoiceInputPageController {
  final VoiceInputService _voiceInputService;
  final SpeakingService _speakingService;
  final HardwareService _hardwareService;

  VoiceInputPageControllerImpl({
    required VoiceInputService voiceInputService,
    required SpeakingService speakingService,
    required HardwareService hardwareService,
  })  : _voiceInputService = voiceInputService,
        _speakingService = speakingService,
        _hardwareService = hardwareService;

  final Rx<String> _currentInput = Rx('');
  @override
  String get currentInput => _currentInput.value;

  final Rx<double> _volume = Rx(0);
  @override
  double get volume => _volume.value;

  final Rx<bool> _isListening = Rx(false);
  @override
  bool get isListening => _isListening.value;

  final Rx<bool> _isInInitial = Rx(true);
  @override
  bool get isInInitial => _isInInitial.value;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final SpeechToText _speechToText = SpeechToText();

  @override
  Future<void> onInit() async {
    super.onInit();

    final bool isBlindModeOn = await A11yUtils.isBlindModeOn();
    if (!isBlindModeOn) {
      _speakingService.speakSentences([
        SpeakItem(
          text: tra(Platform.isAndroid
              ? LocaleKeys.semTitlePage_voiceInputAndroid
              : LocaleKeys.semTitlePage_voiceInputIOS),
        )
      ]);
    }
  }

  @override
  void onClose() {
    _speakingService.pauseCommonPlayer();
    _audioPlayer.dispose();
    _speechToText.cancel();
    super.onClose();
  }

  @override
  Future<void> startListening() async {
    // Debug purpose
    // _handleFinalResult('昨日のKuriのファイルを検索してください');
    // return;

    _speakingService.pauseCommonPlayer();

    // Initialize plugin
    final bool speechAvailable;
    // ! Do NOT use onError, onStatus, etc of .initialize() because they're
    // ! only registered once per app instance
    speechAvailable = await _speechToText.initialize();
    if (speechAvailable == false) {
      return;
    }

    // Start listening
    _playSound(AppSoundAssets.soundBegin);
    _isInInitial.value = false;
    _currentInput.value = '';

    _speechToText.listen(
      localeId: 'ja_JP',
      onResult: (result) {
        _currentInput.value = result.recognizedWords;
        if (result.finalResult) {
          _handleFinalResult(result.recognizedWords);
          _volume.value = 0;
        }
      },
      // Because of different behaviours on iOS & Android
      pauseFor: Platform.isIOS ? Duration(milliseconds: 3000) : null,
      onSoundLevelChange: (soundLevel) {
        // Try to normalize soundLevel to volume.
        // Range of soundLevel on each platform is unknown due
        // to the lack of documentation
        _volume.value = Platform.isIOS ? soundLevel / 30 : soundLevel / 10;
      },
    );

    _speechToText.statusListener = (status) {
      switch (status) {
        case _STT_STATUS_LISTENING:
          _speakingService.startPreventSpeak();
          _hardwareService.enableWakelock();
          break;
        case _STT_STATUS_NOTLISTENING:
          _speakingService.stopPreventSpeak();
          _hardwareService.disableWakelock();
          _volume.value = 0;
          if (currentInput.isEmpty) {
            _playSound(AppSoundAssets.soundCancel);
          }
      }
    };
  }

  Future<void> _handleFinalResult(String input) async {
    final decodedResult = _voiceInputService.decodeVoiceInput(input);

    if (decodedResult == null) {
      // Cannot recognize
      await _speakingService.speakSentences([
        SpeakItem(
          text: tra(
            LocaleKeys.txt_searchResultNotFoundWA,
            namedArgs: {
              'speech': input,
            },
          ),
        )
      ]);
      startListening();
      return;
    }

    // Decode successfully
    _logResult(decodedResult);

    Get.toNamed(
      AppRoutes.voiceInputResult,
      arguments: VoiceInputResultPageArguments(
        result: decodedResult,
      ),
    );
  }

  /// Debugging purpose
  void _logResult(VoiceDecodedResult decodedResult) {
    final from = decodedResult.searchCriteria.dateRange?.fromDate;
    final to = decodedResult.searchCriteria.dateRange?.toDate;
    final originalDateInput =
        decodedResult.searchCriteria.dateRange?.originalDateRangeInput;
    final keyword = decodedResult.searchCriteria.keyword;
    final action = decodedResult.action;

    print('===============================================');
    print('from: $from');
    print('to: $to');
    print('originalDateInput: $originalDateInput');
    print('keyword: $keyword');
    print('action: $action');
    print('===============================================');
  }

  Future<void> _playSound(String soundAsset) async {
    try {
      await _audioPlayer.setAsset(soundAsset);
      _audioPlayer.play();
    } catch (e) {
      // Avoid lib unnecessary exception
    }
  }
}
