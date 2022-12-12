import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/theme/styles.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/onboard_view_utils.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/onboard_permission_page/onboard_permission_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/onboard_permission_page/onboard_permission_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/buttons.dart';

class OnboardPermissionPage extends AppGetView<OnboardPermissionController> {
  OnboardPermissionPage({Key? key})
      : super(
          key: key,
          initialController: OnboardPermissionControllerImpl(),
        );

  @override
  Widget build(BuildContext context, OnboardPermissionController controller) {
    return BaseLayout(
      header: AppHeader(
        titleText: tra(Platform.isAndroid
            ? LocaleKeys.titlePage_onBoardPermissionAndroid
            : LocaleKeys.titlePage_onBoardPermission),
        hideBackButton: true,
        hideMenuButton: true,
      ),
      body: _buildBody(controller),
    );
  }

  Widget _buildBody(OnboardPermissionController controller) {
    final String privacyText = tra(Platform.isAndroid
        ? LocaleKeys.txt_privacyTextAndroid
        : LocaleKeys.txt_privacyText);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!Platform.isAndroid) ...{
                ExcludeSemantics(
                  child: Image.asset(AppAssets.iconPrivacyNotification),
                ),
                SizedBox(
                  width: 40,
                ),
              },
              ExcludeSemantics(
                child: Image.asset(AppAssets.iconPrivacyLocation),
              ),
            ],
          ),
        ),
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
                  AppSemantics(
                    labelList: [privacyText],
                    child: Text(
                      privacyText,
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
                semanticText: tra(LocaleKeys.txt_continue),
                onClick: () async {
                  await controller.requestPermissions();
                  OnboardViewUtils.navigateAfterOnboard();
                },
                color: AppColors.burgundyRed,
                child: Center(
                  child: Text(
                    tra(LocaleKeys.txt_continue),
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
