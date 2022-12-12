import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/tutorial_pages/text/tutorial_onboarding_text.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' show parse;

class TutorialTextPage extends StatelessWidget {
  final SpeakingService speakingService = Get.find<SpeakingService>();

  //TODO fix UI
  List<String> _getHTML() {
    final foundLang = LocalizationUtils.getLanguage();
    String html = "";
    switch (foundLang) {
      case SupportedLanguage.en:
        html = TutorialOnboardingText.tutorialHtmlENG
            .replaceAll("<br><br>", "<br>");
        break;
      case SupportedLanguage.ja:
        html = TutorialOnboardingText.tutorialHtmlJPN
            .replaceAll("<br><br>", "<br>");
        break;
    }
    return html.split("<br>");
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      header: AppHeader(
        titleText: tra(LocaleKeys.titlePage_tutorialPage),
        helpScript: tra(LocaleKeys.helpScript_tutorialText),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final List<String> _rawHtml = _getHTML();
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(AppDimens.paddingNormal),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.paddingSmall),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.black),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: ListView(
                children: [
                  for (int i = 0; i < _rawHtml.length; i++) ...{
                    AppSemantics(
                      labelList: [parse(_rawHtml[i]).documentElement!.text],
                      child: Html(data: _rawHtml[i]),
                    )
                  }
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
