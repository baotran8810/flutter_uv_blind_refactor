abstract class AppSemanticsController {
  String get semanticsId;

  Future<void> speak(
    List<String> labelList, {
    required String? langKey,
    required bool isDocSemantic,
  });
  Future<void> stopSpeaking();
}
