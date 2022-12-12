import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/theme/styles.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/services/speaking_service/speaking_service.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/setting_controller/setting_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/address_select_page/prefecture/prefecture_select_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/buttons.dart';
import 'package:get/get.dart';

class OnboardAddressCollectPage extends StatelessWidget {
  final SpeakingService speakingService = Get.find<SpeakingService>();
  final SettingController _settingController = Get.find();
  final String tutorialText = tra(LocaleKeys.txt_selectAreaGuide);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      header: AppHeader(
        titleText: tra(LocaleKeys.titlePage_onboardAddressCollect),
        semanticsTitle: tra(LocaleKeys.semTitlePage_onboardAddressCollect),
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
                    labelList: [tutorialText],
                    child: Text(
                      tutorialText,
                      style: AppStyles.textContent,
                    ),
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
                semanticText: tra(LocaleKeys.btn_selectYourArea),
                onClick: () {
                  Get.toNamed(
                    AppRoutes.prefectureSelect,
                    arguments: PrefectureSelectPageArguments(
                      onDone: () {
                        _settingController.reloadAddress();
                        Get.offAllNamed(AppRoutes.scan);
                      },
                    ),
                  );
                },
                color: AppColors.burgundyRed,
                child: Center(
                  child: Text(
                    tra(LocaleKeys.btn_selectYourArea),
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
