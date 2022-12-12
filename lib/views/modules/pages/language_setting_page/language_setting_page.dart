import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/language_setting_page/language_setting_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/language_setting_page/language_setting_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/buttons.dart';
import 'package:get/get.dart';

class LanguageSettingPage extends AppGetView<LanguageSettingController> {
  LanguageSettingPage({
    Key? key,
  }) : super(
          key: key,
          initialController: LanguageSettingControllerImpl(
            languageSettingRepository: Get.find(),
          ),
        );

  @override
  Widget build(BuildContext context, LanguageSettingController controller) {
    return BaseLayout(
      header: AppHeader(
        titleText: tra(LocaleKeys.titlePage_languageSetting),
        semanticsTitle: tra(LocaleKeys.semTitlePage_languageSetting),
        helpScript: tra(LocaleKeys.helpScript_languageSetting),
      ),
      body: _buildBody(controller),
    );
  }

  Widget _buildBody(LanguageSettingController controller) {
    return Obx(() {
      final currentLangCode = controller.currentLanguageCode;

      if (controller.isLoadingLanguageList) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        final List<Widget> items = controller.languageList.map(
          (a) {
            final bool isSelected = currentLangCode == a.langKey;

            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.headerBorderColor,
                    width: 1.5,
                  ),
                ),
              ),
              child: AppSemantics(
                labelList: [
                  '${a.jpName} (${a.enName}) ',
                  if (isSelected) tra(LocaleKeys.semTxt_currentSetting),
                ],
                isButton: true,
                child: AppButton(
                  height: 58,
                  color: Colors.transparent,
                  onClick: () {
                    controller.setLanguage(a.langKey);
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: AppDimens.paddingMedium,
                      ),
                      Expanded(
                        child: Text(
                          '${a.jpName} (${a.enName})',
                          style: TextStyle(
                            fontSize: AppDimens.buttonTextFontSize,
                            height: AppDimens.buttonTextLineHeight /
                                AppDimens.buttonTextFontSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Image.asset(AppAssets.iconCheckGreen)
                      else
                        Container(),
                      SizedBox(
                        width: AppDimens.paddingNormal,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ).toList();

        return ListView(
          padding: EdgeInsets.zero,
          children: items,
        );
      }
    });
  }
}
