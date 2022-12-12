import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/miscs/tts_player.dart';
import 'package:just_audio/just_audio.dart';

abstract class SpeakingService {
  Future<void> clearCachedPollyFiles();
  Future<void> configAudioSession();

  // TODO remove `speakSentence` & `stopSpeaking`

  void cancelSpeaking();

  // preventSpeak is to prevent speaking while using SpeechToText feature
  // to avoid app's speaking from being recorded by SpeechToText
  void startPreventSpeak();
  void stopPreventSpeak();

  /// Throw [UnsupportedLanguageException] if cannot get polly AND tts
  ///
  /// `speed`: [SpeakingSpeedRange]
  Future<void> speakSentences(
    List<SpeakItem> speakItemList, {
    bool doCacheFile = true,
    double? speed,
    bool applyPitch = true,
  });
  Future<void> pauseCommonPlayer();

  /// Return playerId
  Future<String> initPlayer();
  void disposePlayer(String playerId);

  /// Throw [UnsupportedLanguageException] if cannot get polly AND tts
  Future<void> setSource({
    required String playerId,
    required List<SpeakItem> speakItemList,
    required AppVoice appVoiceReadingPage,
  });

  Future<void> play(String playerId);
  Future<void> togglePlayOrPause(String playerId);
  Future<void> stop(String playerId);
  Future<void> playFromStart(String playerId);

  Future<void> seekToNext(String playerId);
  Future<void> seekToPrevious(String playerId);

  /// `speed`: [SpeakingSpeedRange]
  Future<void> setSpeed(String playerId, double speed);

  Future<void> toggleMute(String playerId);

  bool getIsPlaying(String playerId);

  Stream<bool> getStreamIsPlaying(String playerId);
  Stream<double> getStreamVolume(String playerId);
  Stream<double> getStreamSpeed(String playerId);
  Stream<int?> getStreamCurrentIndex(String playerId);
  Stream<ProcessingState> getStreamState(String playerId);

  Future<void> pauseAllPlayers();
}

class SpeakItem {
  final String text;
  final String? langKey;

  const SpeakItem({
    required this.text,
    this.langKey,
  });
}

class ConstScript {
  static const kSilence = '<<silence>>';
}
