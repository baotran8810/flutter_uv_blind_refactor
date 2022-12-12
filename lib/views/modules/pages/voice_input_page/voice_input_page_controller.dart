abstract class VoiceInputPageController {
  String get currentInput;
  double get volume;
  bool get isListening;
  bool get isInInitial;

  Future<void> startListening();
}
