import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/a11y_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/views/controllers/semantics_manage_controller/semantics_manage_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_dialog.dart';
import 'package:get/get.dart';

abstract class DialogViewUtils {
  // ! Workaround because of get: ^4.3.6 bug
  // All showDialog function should await this first
  // Reason:
  // In get: ^4.3.6, showing a dialog AT THE SAME TIME as building an
  // AppGetView widget (outside of the dialog) will cause GetX to think
  // that the AppGetView's controller belongs to the Dialog => on dialog
  // close, GetX will dispose the AppGetView's controller => cause a severe
  // bug.
  static Future<void> _waitGetX() async {
    await Future.delayed(Duration(milliseconds: 100));
  }

  static Future<T?> _handleShowDialog<T>({
    required Widget dialog,
  }) async {
    await _waitGetX();
    final isBlindModeOn = await A11yUtils.isBlindModeOn();

    final semanticsManageController = Get.find<SemanticsManageController>();

    // Focus a11 back to the previous button after closing dialog
    semanticsManageController.queueFocusing();
    // final result = await showDialogFunc();
    final result = await Get.dialog<T>(
      dialog,
      // Workaround to fix a bug: VoiceOver focusing on dismissable instead of
      // content first when dialog opened
      // ignore: avoid_bool_literals_in_conditional_expressions
      barrierDismissible: Platform.isIOS && isBlindModeOn ? false : true,
    );
    semanticsManageController.focusQueueing();

    return result;
  }

  static Future<bool> showConfirmDialog({
    String? textYes,
    String? titleText,
    String? textNo,
    required String messageText,
  }) async {
    final result = await _handleShowDialog<bool>(
      dialog: AppDialogYesNo(
        textYes: textYes,
        textNo: textNo,
        titleText: titleText ?? tra(LocaleKeys.txt_confirm),
        messageText: messageText,
        onYes: () {
          Get.back(result: true);
        },
      ),
    );
    return result ?? false;
  }

  static Future<void> showAlertDialog({
    required String messageText,
  }) async {
    await _handleShowDialog(
      dialog: AppDialog(
        body: Column(
          children: [
            SizedBox(height: 24),
            AppSemantics(
              labelList: [messageText],
              child: Text(
                messageText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
        actions: [
          AppDialogAction(
            onPressed: () {
              Get.back();
            },
            text: tra(LocaleKeys.btn_ok),
            btnColor: AppColors.burgundyRed,
          ),
        ],
      ),
    );
  }
}
