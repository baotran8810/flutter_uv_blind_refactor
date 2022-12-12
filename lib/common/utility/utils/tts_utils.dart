import 'package:flutter_tts/flutter_tts.dart';
import 'package:uuid/uuid.dart';

class TtsInstance {
  final void Function(bool isPlaying) setIsPlayingFunc;
  final void Function(int readingIndex) setCurrentWordIndexFunc;

  TtsInstance({
    required this.setIsPlayingFunc,
    required this.setCurrentWordIndexFunc,
  });
}

// There can only be 1 instance of TTS (for handlers, etc) in native side
// so we have to do this to make it per instance
class TtsUtils {
  static final flutterTts = FlutterTts();

  static final Map<String, TtsInstance> _instanceIdWithInstanceMap = {};

  static bool _hasInit = false;

  static void init() {
    if (_hasInit) {
      return;
    }

    _hasInit = true;

    flutterTts.awaitSpeakCompletion(true);
    flutterTts.awaitSynthCompletion(false);

    flutterTts.setStartHandler(() {
      print('Start');
      _triggerIsPlayingFuncList(true);
    });
    flutterTts.setCompletionHandler(() {
      print('Completion');
      _triggerIsPlayingFuncList(false);
    });
    flutterTts.setCancelHandler(() {
      print('Cancel');
      _triggerIsPlayingFuncList(false);
    });
    flutterTts.setPauseHandler(() {
      print('Pause');
      _triggerIsPlayingFuncList(false);
    });
    flutterTts.setContinueHandler(() {
      print('Continue');
      _triggerIsPlayingFuncList(true);
    });
    flutterTts.setErrorHandler((message) {
      print('Error $message');
      _triggerIsPlayingFuncList(false);
    });
    flutterTts.setProgressHandler((text, start, end, word) {
      // Trigger all setCurrentWordIndexFunc
      _instanceIdWithInstanceMap.forEach((instanceId, instance) {
        instance.setCurrentWordIndexFunc(start);
      });
    });
  }

  static void _triggerIsPlayingFuncList(bool isPlaying) {
    // Trigger all setIsPlayingFunc
    _instanceIdWithInstanceMap.forEach((handlerId, ttsHandlers) {
      ttsHandlers.setIsPlayingFunc(isPlaying);
    });
  }

  /// Return `id` of handlers
  static String registerTtsInstance({
    required void Function(bool isPlaying) setIsPlayingFunc,
    required void Function(int readingIndex) setProgressFunc,
  }) {
    final instanceId = Uuid().v4();
    _instanceIdWithInstanceMap[instanceId] = TtsInstance(
      setIsPlayingFunc: setIsPlayingFunc,
      setCurrentWordIndexFunc: setProgressFunc,
    );

    return instanceId;
  }

  static void unregisterHandlers(String handlerId) {
    _instanceIdWithInstanceMap.remove(handlerId);
  }
}
