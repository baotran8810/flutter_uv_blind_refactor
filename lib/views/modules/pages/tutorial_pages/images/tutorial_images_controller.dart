import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

abstract class TutorialImagesController {
  PageController get pageController;
  int get currentPage;
  List<TutorialPage> get tutorialPages;
  void onPageChanged(int index);
  Future<void> speak(String sentence);
  void toNextPage();
}

class TutorialPage {
  final String semanticsId;
  final String screenshot;
  final String text;
  final String semanticsText;

  TutorialPage({
    required this.screenshot,
    required this.text,
    required this.semanticsText,
  }) : semanticsId = Uuid().v4();
}
