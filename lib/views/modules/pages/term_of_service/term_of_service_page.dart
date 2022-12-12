import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/theme/styles.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/term_of_service/text/term_of_service_text.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/buttons.dart';
import 'package:get/get.dart';

class TermOfServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      header: AppHeader(
        titleText: tra(LocaleKeys.titlePage_termOfService),
        semanticsTitle: tra(LocaleKeys.semTitlePage_termOfService),
        hideBackButton: true,
        hideMenuButton: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    List<String> _getText() {
      String _localizationText = "";
      final foundLang = LocalizationUtils.getLanguage();
      switch (foundLang) {
        case SupportedLanguage.en:
          _localizationText = TermOfServiceText.TermOfServiceHTMLENG;
          break;

        case SupportedLanguage.ja:
          _localizationText = TermOfServiceText.TermOfServiceHTMLJPN;
          break;
      }
      return _localizationText.split("\n\n");
    }

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
                  for (int i = 0; i < _getText().length; i++) ...{
                    AppSemantics(
                      labelList: [_getText()[i]],
                      child: Text(
                        _getText()[i],
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  }
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
                semanticText: tra(LocaleKeys.txt_close),
                onClick: _onExitClick,
                child: Center(
                  child: Text(
                    tra(LocaleKeys.txt_close),
                    style: AppStyles.buttonText,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: AppDimens.paddingNormal,
            ),
            Expanded(
              child: AppButton(
                semanticText: tra(LocaleKeys.txt_agree),
                onClick: () {
                  Get.toNamed(AppRoutes.tutorialTextOnboard);
                },
                color: AppColors.burgundyRed,
                child: Center(
                  child: Text(
                    tra(LocaleKeys.txt_agree),
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

  void _onExitClick() {
    exit(0);
  }
}
