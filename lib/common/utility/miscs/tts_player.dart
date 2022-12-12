import 'dart:async';
import 'dart:io';

import 'package:flutter_uv_blind_refactor/common/utility/extensions/double_extension.dart';
import 'package:flutter_uv_blind_refactor/common/utility/miscs/debouncer.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/internet_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/tts_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/app_setting/app_setting_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:just_audio/just_audio.dart';

final Debouncer _debouncer = Debouncer();

class TtsPlayer {
  final _flutterTts = TtsUtils.flutterTts;

  List<SpeakItem> _speakItemList = [];

  double _volume = 1;

  int _currentSentenceIndex = 0;
  int _currentWordIndex = 0;

  bool _isPlaying = false;

  /// Only for iOS
  bool _stopSpeaking = false;

  final StreamController<bool> _scIsPlaying = StreamController.broadcast();
  final StreamController<int> _scCurrentIndex = StreamController.broadcast();
  final StreamController<double> _scSpeed = StreamController.broadcast();
  final StreamController<double> _scVolume = StreamController.broadcast();
  final StreamController<ProcessingState> _scProcessingState =
      StreamController.broadcast();

  bool get isPlaying => _isPlaying;
  double get volume => _volume;

  late String _instanceId;

  TtsPlayer() {
    _instanceId = TtsUtils.registerTtsInstance(
      setIsPlayingFunc: _setIsPlaying,
      setProgressFunc: _setCurrentWordIndex,
    );
  }

  // ignore: use_setters_to_change_properties
  void _setCurrentWordIndex(int currentWordIndex) {
    _currentWordIndex = currentWordIndex;
  }

  /// Throw [UnsupportedLanguageException] if cannot get polly AND tts
  Future<void> setSource({
    required List<SpeakItem> speakItemList,
  }) async {
    stop();

    _speakItemList = List.from(speakItemList);
    _setCurrentIndex(0);

    for (final speakItem in _speakItemList) {
      final langTag = _getLangTagWithFallback(speakItem.langKey);

      // Android will automatically download the language if it has internet
      final isLangAvailable = Platform.isAndroid
          ? await InternetUtils.hasInternet()
              ? await _flutterTts.isLanguageAvailable(langTag) as bool
              : await _flutterTts.isLanguageInstalled(langTag) as bool
          : await _flutterTts.isLanguageAvailable(langTag) as bool;

      if (!isLangAvailable) {
        throw UnsupportedLanguageException(langTag);
      }
    }
  }

  Future<void> dispose() async {
    await Future.wait([
      _scIsPlaying.close(),
      _scCurrentIndex.close(),
      _scSpeed.close(),
      _scVolume.close(),
      _scProcessingState.close(),
    ]);
    TtsUtils.unregisterHandlers(_instanceId);
  }

  String _getLangTagWithFallback(String? langKey) {
    final finalLangKey = LocalizationUtils.getLangKeyWithFallback(langKey);
    final locale = LocalizationUtils.getLocaleByLangKey(finalLangKey);
    return locale.toLanguageTag();
  }

  Future<void> play() async {
    for (int i = _currentSentenceIndex; i < _speakItemList.length; i++) {
      // Delay: workaround to force to wait after
      // setCompletionHandler was called
      await Future.delayed(Duration.zero);

      _setCurrentIndex(i);

      final speakItem = _speakItemList[i];

      if (speakItem.text == ConstScript.kSilence) {
        await Future.delayed(Duration(milliseconds: 100));
      } else {
        final sentenceToSpeak = speakItem.text.substring(_currentWordIndex);

        final langTag = _getLangTagWithFallback(speakItem.langKey);
        await _flutterTts.setLanguage(langTag);
        await _flutterTts.speak(sentenceToSpeak);
      }

      // Only on iOS
      if (_stopSpeaking) {
        break;
      }

      _setCurrentWordIndex(0);
    }
  }

  Future<void> pause() async {
    if (_isPlaying) {
      await _flutterTts.stop();

      // Workaround because tts.stop() on Android doesn't continue await tts.speak()
      if (Platform.isIOS) {
        _stopSpeaking = true;

        // Wait for any playing player to stop
        Future.delayed(Duration(milliseconds: 1000), () {
          _stopSpeaking = false;
        });
      }

      // To handle the case where we play immediately after pause
      // await pause()/stop()
      // await play()
      await Future.delayed(Duration(milliseconds: 300));
    }
  }

  Future<void> stop() async {
    _setCurrentWordIndex(0);
    await pause();
  }

  Future<void> seekToNext() async {
    if (_currentSentenceIndex + 1 < _speakItemList.length) {
      _setCurrentIndex(_currentSentenceIndex + 1);
    }

    // For fast seeking
    _debouncer.run(() async {
      if (_isPlaying) {
        await stop();
        await play();
      }
    });
  }

  Future<void> seekToPrevious() async {
    if (_currentSentenceIndex - 1 >= 0) {
      _setCurrentIndex(_currentSentenceIndex - 1);
    }

    // For fast seeking
    _debouncer.run(() async {
      if (_isPlaying) {
        await stop();
        await play();
      }
    });
  }

  Future<void> seekToStart() async {
    _setCurrentIndex(0);

    if (_isPlaying) {
      await stop();
      await play();
    }
  }

  void _setCurrentIndex(int currentIndex) {
    _currentSentenceIndex = currentIndex;
    _scCurrentIndex.add(currentIndex);
  }

  /// [0.5, 2]
  Future<void> setSpeed(double speed) async {
    final range = await _flutterTts.getSpeechRateValidRange;
    print('min: ${range.min}, max: ${range.max}');

    // Map from <our speed> to <tts speed> value
    final double ttsSpeed = speed.map(
      // Our speed value range
      inputMin: SpeakingSpeedRange.kMin,
      inputMax: SpeakingSpeedRange.kMax,
      // Tts speed value range
      outputMin: 0.25,
      outputMax: 1,
    );

    await _flutterTts.setSpeechRate(ttsSpeed);

    _scSpeed.add(speed);

    await pause();
  }

  Future<void> setVolume(double volume) async {
    await _flutterTts.setVolume(volume);
    _volume = volume;
    _scVolume.add(volume);

    await pause();
  }

  Future<void> setPitch(double pitch) async {
    await _flutterTts.setPitch(pitch.map(
      inputMin: SpeakingPitchRange.kMin,
      inputMax: SpeakingPitchRange.kMax,
      outputMin: 0.5,
      outputMax: 2,
    ));
  }

  void _setIsPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    _scIsPlaying.add(isPlaying);

    if (isPlaying) {
      // TODO correct this
      _scProcessingState.add(ProcessingState.buffering);
    } else {
      if (_currentSentenceIndex == _speakItemList.length - 1) {
        _scProcessingState.add(ProcessingState.completed);
      }
    }
  }

  Stream<bool> getStreamIsPlaying() {
    return _scIsPlaying.stream;
  }

  Stream<int> getStreamCurrentIndex() {
    return _scCurrentIndex.stream;
  }

  Stream<double> getStreamSpeed() {
    return _scSpeed.stream;
  }

  Stream<double> getStreamVolume() {
    return _scVolume.stream;
  }

  Stream<ProcessingState> getStreamProcessingState() {
    return _scProcessingState.stream;
  }
}

class UnsupportedLanguageException implements Exception {
  final String langTag;

  UnsupportedLanguageException(this.langTag);
}
