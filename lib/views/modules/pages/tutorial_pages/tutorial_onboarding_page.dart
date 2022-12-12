import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/theme/styles.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/onboard_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/repositories/app_data_repository/app_data_repository.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/tutorial_pages/text/tutorial_onboarding_text.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/buttons.dart';
import 'package:get/get.dart';

class TutorialOnboardingPage extends StatelessWidget {
  final AppDataRepository _appDataRepository = Get.find();

  TutorialOnboardingPage({
    Key? key,
  }) : super(key: key);

  String _getText() {
    final foundLang = LocalizationUtils.getLanguage();
    switch (foundLang) {
      case SupportedLanguage.en:
        return TutorialOnboardingText.tutorialTextENG;
      case SupportedLanguage.ja:
        return TutorialOnboardingText.tutorialTextJPN;
    }
  }

  Widget _buildHtml() {
    final foundLang = LocalizationUtils.getLanguage();
    switch (foundLang) {
      case SupportedLanguage.en:
        return Html(data: TutorialOnboardingText.tutorialTxtHtmlENG);
      case SupportedLanguage.ja:
        return Html(data: TutorialOnboardingText.tutorialTxtHtmlJPN);
    }
  }

  Future<void> _onPressedNext() async {
    await _appDataRepository.saveData(
      isOnboardCompleted: true,
    );

    OnboardViewUtils.navigateAfterOnboard();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      header: AppHeader(
        titleText: tra(LocaleKeys.titlePage_tutorial),
        hideBackButton: true,
        hideMenuButton: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(AppDimens.paddingNormal),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.paddingSmall),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  AppSemantics(
                    labelList: [_getText()],
                    child: _buildHtml(),
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 53,
            ),
            Expanded(
              child: AppButton(
                semanticText: tra(LocaleKeys.txt_start),
                onClick: _onPressedNext,
                color: AppColors.burgundyRed,
                child: Center(
                  child: Text(
                    tra(LocaleKeys.txt_start),
                    style: AppStyles.buttonText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 53,
            ),
          ],
        ),
        SizedBox(
          height: AppDimens.paddingNormal,
        ),
      ],
    );
  }
}
