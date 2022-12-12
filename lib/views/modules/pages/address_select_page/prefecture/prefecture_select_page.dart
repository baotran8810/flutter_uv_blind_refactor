import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/address/address_dto.dart';
import 'package:flutter_uv_blind_refactor/routes/app_routes.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/address_select_page/prefecture/prefecture_select_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/address_select_page/prefecture/prefecture_select_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/address_select_page/ward/ward_select_page.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/buttons.dart';
import 'package:get/get.dart';

class PrefectureSelectPageArguments {
  final void Function() onDone;

  PrefectureSelectPageArguments({required this.onDone});
}

class PrefectureSelectPage extends AppGetView<PrefectureSelectController> {
  final PrefectureSelectPageArguments arguments;

  PrefectureSelectPage({
    Key? key,
    required this.arguments,
  }) : super(
          key: key,
          initialController: PrefectureSelectControllerImpl(
            addressRepository: Get.find(),
          ),
        );

  @override
  Widget build(BuildContext context, PrefectureSelectController controller) {
    return BaseLayout(
      header: AppHeader(
        titleText: tra(LocaleKeys.titlePage_selectPrefecture),
        semanticsTitle: tra(LocaleKeys.titlePage_selectPrefecture),
        helpScript: tra(LocaleKeys.helpScript_selectPrefecture),
        hideMenuButton: true,
      ),
      body: _buildBody(controller),
    );
  }

  Widget _buildBody(PrefectureSelectController controller) {
    return Obx(() {
      final bool isLoading = controller.isLoadingAddressList;
      final currentTagData = controller.currentAddressTagData;
      final List<AddressDto> prefectureList = controller.prefectureList;

      if (isLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      final List<Widget> items = prefectureList.map(
        (address) {
          final bool isSelected =
              address.tagData.prefecture == currentTagData?.prefecture;

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
                address.prefectureName,
                if (isSelected) tra(LocaleKeys.semTxt_currentSetting),
              ],
              isButton: true,
              child: AppButton(
                borderRadius: 0,
                height: 58,
                color: isSelected ? AppColors.burgundyRed : Colors.transparent,
                onClick: () {
                  Get.toNamed(
                    AppRoutes.wardSelect,
                    arguments: WardSelectPageArguments(
                      prefectureName: address.prefectureName,
                      onDone: arguments.onDone,
                    ),
                  );
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: AppDimens.paddingMedium,
                    ),
                    Expanded(
                      child: Text(
                        address.prefectureName,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: AppDimens.buttonTextFontSize,
                          height: AppDimens.buttonTextLineHeight /
                              AppDimens.buttonTextFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: isSelected ? Colors.white : AppColors.gray03,
                    ),
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
    });
  }
}
