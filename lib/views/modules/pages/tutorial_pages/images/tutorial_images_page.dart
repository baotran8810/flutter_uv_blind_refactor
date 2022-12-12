import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/extensions.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/semantics_manage_controller/semantics_manage_controller.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/tutorial_pages/images/tutorial_images_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/tutorial_pages/images/tutorial_images_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:get/get.dart';

class TutorialImagesPage extends AppGetView<TutorialImagesController> {
  final SemanticsManageController _semanticsManageController;

  TutorialImagesPage({Key? key})
      : _semanticsManageController = Get.find(),
        super(
          key: key,
          initialController:
              TutorialImagesControllerImpl(readingService: Get.find()),
        );

  @override
  Widget build(BuildContext context, TutorialImagesController controller) {
    return BaseLayout(
      header: AppHeader(
        titleText: tra(LocaleKeys.titlePage_tutorialPhoto),
        helpScript: tra(LocaleKeys.helpScript_tutorialPhoto),
      ),
      body: _buildBody(controller),
    );
  }

  Widget _buildBody(TutorialImagesController controller) {
    return Stack(
      children: [
        Obx(() {
          final pageController = controller.pageController;
          final tutorialPages = controller.tutorialPages;

          return PageView(
            controller: pageController,
            onPageChanged: (index) {
              final tutorialPage = tutorialPages[index];

              controller.onPageChanged(index);

              _semanticsManageController.focus(
                tutorialPage.semanticsId,
                defocusIfNotAvailable: false,
              );
            },
            children: tutorialPages
                .map(
                  (page) => _buildTutorialPage(page, controller),
                )
                .toList(),
          );
        }),
        Positioned(
          bottom: AppDimens.paddingNormal,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildPageIndicators(controller),
          ),
        ),
      ],
    );
  }

  Widget _buildTutorialPage(
      TutorialPage page, TutorialImagesController controller) {
    return AppSemantics(
      semanticId: page.semanticsId,
      labelList: [page.semanticsText],
      child: GestureDetector(
        onTap: () {
          controller.toNextPage();
        },
        child: Container(
          color: AppColors.gray,
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
          child: Column(
            children: [
              AppSemantics(
                labelList: [page.text],
                child: Text(
                  page.text,
                  style: TextStyle(
                    color: AppColors.textBlack,
                    fontSize: 16,
                    height: 23 / 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Expanded(
                child: Image.asset(page.screenshot),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicators(TutorialImagesController controller) {
    return controller.tutorialPages
        .mapIndexed(
          (page, index) => Obx(
            () {
              return Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  color: controller.currentPage == index
                      ? AppColors.burgundyRed
                      : AppColors.gray02,
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: EdgeInsets.symmetric(horizontal: 3),
              );
            },
          ),
        )
        .toList();
  }
}
