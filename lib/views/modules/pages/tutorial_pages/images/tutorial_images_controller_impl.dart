import 'package:flutter/widgets.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:get/get.dart';

import 'tutorial_images_controller.dart';

class TutorialImagesControllerImpl extends GetxController
    implements TutorialImagesController {
  final PageController controller = PageController();
  final SpeakingService _readingService;

  TutorialImagesControllerImpl({required SpeakingService readingService})
      : _readingService = readingService;

  final Rx<int> _currentPage = 0.obs;

  @override
  int get currentPage => _currentPage.value;

  @override
  void onPageChanged(int index) {
    _currentPage.value = index;
  }

  @override
  Future<void> speak(String sentence) async {
    await _readingService.speakSentences([SpeakItem(text: sentence)]);
  }

  @override
  void toNextPage() {
    int temp = 0;
    if (_currentPage.value + 1 < tutorialPages.length) {
      temp = _currentPage.value + 1;
    }
    controller.animateToPage(temp,
        duration: Duration(milliseconds: 350), curve: Curves.easeIn);
  }

  @override
  PageController get pageController => Rx(controller).value;

  @override
  List<TutorialPage> get tutorialPages => Rx([
        TutorialPage(
          screenshot: AppAssets.screenshot10,
          text: tra(LocaleKeys.txt_tutorialImage10),
          semanticsText: tra(LocaleKeys.txt_tutorialImage10),
        ),
        TutorialPage(
          screenshot: AppAssets.screenshot01,
          text: tra(LocaleKeys.txt_tutorialImage01),
          semanticsText: tra(LocaleKeys.txt_tutorialImage01),
        ),
        TutorialPage(
          screenshot: AppAssets.screenshot07,
          text: tra(LocaleKeys.txt_tutorialImage07),
          semanticsText: tra(LocaleKeys.txt_tutorialImage07),
        ),
        TutorialPage(
          screenshot: AppAssets.screenshot09,
          text: tra(LocaleKeys.txt_tutorialImage09),
          semanticsText: tra(LocaleKeys.txt_tutorialImage09),
        ),
        TutorialPage(
          screenshot: AppAssets.screenshot02,
          text: tra(LocaleKeys.txt_tutorialImage02),
          semanticsText: tra(LocaleKeys.txt_tutorialImage02),
        ),
        TutorialPage(
          screenshot: AppAssets.screenshot08,
          text: tra(LocaleKeys.txt_tutorialImage08),
          semanticsText: tra(LocaleKeys.txt_tutorialImage08),
        ),
        TutorialPage(
          screenshot: AppAssets.screenshot05,
          text: tra(LocaleKeys.txt_tutorialImage05),
          semanticsText: tra(LocaleKeys.txt_tutorialImage05),
        ),
        TutorialPage(
          screenshot: AppAssets.screenshot04,
          text: tra(LocaleKeys.txt_tutorialImage04),
          semanticsText: tra(LocaleKeys.txt_tutorialImage04),
        ),
        TutorialPage(
          screenshot: AppAssets.screenshot03,
          text: tra(LocaleKeys.txt_tutorialImage03),
          semanticsText: tra(LocaleKeys.txt_tutorialImage03),
        ),
      ]).value;
}
