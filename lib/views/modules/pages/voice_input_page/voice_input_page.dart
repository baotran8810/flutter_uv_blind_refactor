import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/voice_input_page/voice_input_page_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/voice_input_page/voice_input_page_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/micro_volume.dart';
import 'package:get/get.dart';

// const _readBtnTag = 'readBtnTag';

class VoiceInputPage extends AppGetView<VoiceInputPageController> {
  VoiceInputPage({Key? key})
      : super(
          key: key,
          initialController: VoiceInputPageControllerImpl(
            voiceInputService: Get.find(),
            speakingService: Get.find(),
            hardwareService: Get.find(),
          ),
        );

  @override
  Widget build(
    BuildContext context,
    VoiceInputPageController controller,
  ) {
    return BaseLayout(
      header: AppHeader(
        titleText: tra(LocaleKeys.titlePage_voiceInput),
        semanticsTitle: tra(Platform.isAndroid
            ? LocaleKeys.semTitlePage_voiceInputAndroid
            : LocaleKeys.semTitlePage_voiceInputIOS),
        helpScript: tra(Platform.isAndroid
            ? LocaleKeys.semTitlePage_voiceInputAndroid
            : LocaleKeys.semTitlePage_voiceInputIOS),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInputBox(controller),
          Expanded(
            child: _buildStartBtn(controller),
          ),
        ],
      ),
      // ! Temp disable because local_hero 0.2.0 doesn't work with flutter 2.8
      // body: LocalHeroScope(
      //   duration: Duration(milliseconds: 100),
      //   curve: Curves.easeIn,
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.stretch,
      //     children: [
      //       _buildInputBox(controller),
      //       Expanded(
      //         child: LocalHero(
      //           tag: _readBtnTag,
      //           child: _buildStartBtn(controller),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildInputBox(VoiceInputPageController controller) {
    return Obx(
      () {
        final isInInitial = controller.isInInitial;

        if (isInInitial) {
          return SizedBox();
        }

        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: AppDimens.paddingNormal,
              horizontal: AppDimens.paddingNormal,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.paddingNormal,
              vertical: AppDimens.paddingSmall,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(),
            ),
            child: Obx(
              () {
                final String speechText = controller.currentInput;
                return Text(
                  speechText,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildStartBtn(VoiceInputPageController controller) {
    return Obx(
      () {
        final isInInitial = controller.isInInitial;

        return AppSemantics(
          labelList: [
            isInInitial
                ? tra(Platform.isAndroid
                    ? LocaleKeys.semBtn_voiceInputReadAndroid
                    : LocaleKeys.semBtn_voiceInputReadIOS)
                : tra(LocaleKeys.btn_talkAgain)
          ],
          isButton: true,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                controller.startListening();
              },
              child: Ink(
                color: Color(0xFFA21942),
                child: Center(
                  child: isInInitial
                      ? _buildInitialtModeBtnChild()
                      : _buildListenModeChild(controller),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInitialtModeBtnChild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.record_voice_over,
          color: Colors.white,
          size: 70,
        ),
        SizedBox(width: AppDimens.paddingNormal),
        Text(
          tra(LocaleKeys.btn_read),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildListenModeChild(VoiceInputPageController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
          () {
            final double volume = controller.volume;

            return MicroVolume(
              volume: volume,
              endRadius: 70,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.mic,
                  color: Color(0xFFA21942),
                  size: 40,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 20),
        Text(
          tra(LocaleKeys.btn_talkAgain),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
