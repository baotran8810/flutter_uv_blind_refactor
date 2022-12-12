import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';

abstract class ReadingPageController {
  // === Miscs
  bool get isLoading;
  bool get isBlindModeOn;
  TextEditingController get textControllerTitle;
  bool get isBookmark;

  List<String> get langKeyList;

  String get selectedLangKey;
  List<SentenceItem> get sentenceItemList;
  List<String> get sentenceList;

  /// Used to disable title semantic temporarily
  bool get isPlayingAutoplayBlindMode;

  // === Audio player

  double get currentVolume;
  double get currentSpeed;
  bool get isCompleted;
  bool get isPlaying;
  int get currentPlayerIndex;
  AppVoice get appVoiceReadingPage;

  // === For auto scroll

  List<GlobalKey<State<StatefulWidget>>> get sentenceWidgetKeys;

  // ==== Miscs

  /// Switch language, add listeners & play if needed.
  /// This future wait for play() to complete.
  Future<void> initOrSwitchLanguage(
    String langKey, {
    bool isInit = false,
  });
  void copyContent();
  void sendEmail();
  Future<void> deleteCode();
  Future<void> setBookmark();
  void changeTitle();

  // ==== Audio player

  void playFromStart();
  void seekToPrevious();
  void seekToNext();
  void togglePlayOrPause();
  Future<void> setSpeed(double speed);
  void toggleMute();
  Future<void> setAppVoice(AppVoice value);

  String? get originalUrl;
}

class SentenceItem {
  final String content;
  final String separator;

  SentenceItem({
    required this.content,
    required this.separator,
  });

  String getSentence() {
    return '$content$separator';
  }
}
