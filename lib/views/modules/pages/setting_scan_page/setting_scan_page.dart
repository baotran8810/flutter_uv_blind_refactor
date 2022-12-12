import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/setting_scan_page/setting_scan_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/setting_scan_page/setting_scan_page_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:get/get.dart';
import 'package:invert_colors/invert_colors.dart';

// Order matters
List<String> _borderLevelSemTextList = [
  tra(LocaleKeys.semTxt_narrow),
  tra(LocaleKeys.semTxt_middle),
  tra(LocaleKeys.semTxt_bold),
];

// Order matters. Should match with AppColors.scanBorderColorList
List<String> _borderColorSemTextList = [
  tra(LocaleKeys.semTxt_colorWhite),
  tra(LocaleKeys.semTxt_colorBlack),
  tra(LocaleKeys.semTxt_colorRed),
  tra(LocaleKeys.semTxt_colorBlue),
];

class SettingScanPage extends AppGetView<SettingScanPageController> {
  SettingScanPage({Key? key})
      : super(
          key: key,
          initialController: SettingScanPageControllerImpl(
            appSettingRepository: Get.find(),
          ),
        );

  @override
  Widget build(BuildContext context, controller) {
    return BaseLayout(
      header: _buildHeader(context, controller),
      body: _buildBody(context, controller),
    );
  }
}

Widget _buildHeader(
    BuildContext context, SettingScanPageController controller) {
  return AppHeader(
    titleText: tra(LocaleKeys.titlePage_settingScan),
    semanticsTitle: tra(LocaleKeys.semTitlePage_settingScan),
    helpScript: tra(LocaleKeys.helpScript_scanSetting),
  );
}

Widget _buildBody(BuildContext context, SettingScanPageController controller) {
  return SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.fromLTRB(
        AppDimens.paddingNormal,
        AppDimens.paddingNormal,
        AppDimens.paddingNormal,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () {
              final selectedBorderLevelIndex =
                  controller.selectedBorderLevelIndex;

              return _buildTitle(
                tra(LocaleKeys.txt_thicknessSetting),
                tra(
                  LocaleKeys.semTxt_thicknessSettingWA,
                  namedArgs: {
                    "currentValue":
                        _borderLevelSemTextList[selectedBorderLevelIndex]
                  },
                ),
              );
            },
          ),
          SizedBox(height: AppDimens.paddingNormal),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              final double thickness = 3 + index * 2;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      height: 30 + thickness,
                      child: Obx(
                        () {
                          final selectedBorderLevelIndex =
                              controller.selectedBorderLevelIndex;

                          if (index == selectedBorderLevelIndex) {
                            return AppSemantics(
                              labelList: [
                                tra(
                                  LocaleKeys.semTxt_currentThicknessSettingWA,
                                  namedArgs: {
                                    "currentValue":
                                        _borderLevelSemTextList[index]
                                  },
                                ),
                              ],
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.selectBorderLevel(index);
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xffA21942))),
                                child: Divider(
                                  thickness: thickness,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          } else {
                            return AppSemantics(
                              labelList: [_borderLevelSemTextList[index]],
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.selectBorderLevel(index);
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xffffffff))),
                                child: Divider(
                                  thickness: thickness,
                                  color: const Color(0xffA21942),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: AppDimens.paddingMedium),
          Obx(
            () {
              return _buildTitle(
                tra(LocaleKeys.txt_colorSetting),
                tra(
                  LocaleKeys.semTxt_colorSettingWA,
                  namedArgs: {
                    "currentValue":
                        _borderColorSemTextList[controller.selectedColorIndex]
                  },
                ),
              );
            },
          ),
          SizedBox(height: AppDimens.paddingNormal),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: AppColors.scanBorderColorList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: AppDimens.paddingNormal,
              mainAxisSpacing: AppDimens.paddingNormal,
            ),
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              return Obx(
                () => Stack(
                  fit: StackFit.expand,
                  children: [
                    ExcludeSemantics(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                          color: AppColors.scanBorderColorList[index],
                        ),
                        child: TextButton(
                          onPressed: () {
                            controller.selectColor(index);
                          },
                          child: const Text(""),
                        ),
                      ),
                    ),
                    if (index == controller.selectedColorIndex)
                      AppSemantics(
                        labelList: [
                          tra(
                            LocaleKeys.semTxt_currentColorSettingWA,
                            namedArgs: {
                              "currentValue": _borderColorSemTextList[index]
                            },
                          ),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: InvertColors(
                            child: SvgPicture.asset(
                              AppAssets.iconCheckSVG,
                              color: AppColors.scanBorderColorList[index],
                            ),
                          ),
                        ),
                      )
                    else
                      AppSemantics(
                        labelList: [_borderColorSemTextList[index]],
                        child: Container(),
                      ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: AppDimens.paddingMedium),
          Obx(
            () => _buildTitle(
              tra(LocaleKeys.txt_preview),
              tra(
                LocaleKeys.semTxt_scanSettingPreviewWA,
                namedArgs: {
                  "currentColorValue":
                      _borderColorSemTextList[controller.selectedColorIndex],
                  "currentThicknessValue": _borderLevelSemTextList[
                      controller.selectedBorderLevelIndex]
                },
              ),
            ),
          ),
          SizedBox(height: AppDimens.paddingNormal),
          Obx(
            () => Container(
              width: double.infinity,
              height: 200,
              color: controller.selectedColorIndex == 0
                  ? Colors.black
                  : Colors.transparent,
              child: Container(
                padding: EdgeInsets.only(top: AppDimens.paddingMedium),
                width: 164,
                height: 164,
                child: CustomPaint(
                  painter: OpenPainter(
                      controller.selectedBorderLevelIndex.toDouble(),
                      AppColors
                          .scanBorderColorList[controller.selectedColorIndex]),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildTitle(String text, String label) {
  return AppSemantics(
    labelList: [label],
    child: Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    ),
  );
}

class OpenPainter extends CustomPainter {
  double borderLevel;
  Color color;

  OpenPainter(this.borderLevel, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = color
      ..strokeWidth = (borderLevel + 1) * 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    //a rectangle
    canvas.drawRect(const Offset(100, 0) & const Size(150, 150), paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
