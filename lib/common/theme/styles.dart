import 'package:flutter/cupertino.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';

class AppStyles {
  static const TextStyle headerText = TextStyle(
    fontSize: AppDimens.headerTextFontSize,
    height: AppDimens.headerTextLineHeight / AppDimens.headerTextFontSize,
    color: AppColors.textBlack,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle textContent = TextStyle(
    fontSize: AppDimens.contentTextFontSize,
    height: AppDimens.contentTextLineHeight / AppDimens.contentTextFontSize,
    color: AppColors.textBlack,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: AppDimens.buttonTextFontSize,
    height: AppDimens.buttonTextLineHeight / AppDimens.buttonTextFontSize,
    color: AppColors.white,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle headerTextWhite = TextStyle(
    fontSize: AppDimens.headerTextFontSize,
    height: AppDimens.headerTextLineHeight / AppDimens.headerTextFontSize,
    color: AppColors.white,
    fontWeight: FontWeight.w700,
  );
}
