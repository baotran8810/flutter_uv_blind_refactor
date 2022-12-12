import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/address/address_dto.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/address_select_page/ward/ward_select_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/address_select_page/ward/ward_select_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/buttons.dart';
import 'package:get/get.dart';

class WardSelectPageArguments {
  final String prefectureName;
  final void Function() onDone;

  WardSelectPageArguments({
    required this.prefectureName,
    required this.onDone,
  });
}

class WardSelectPage extends AppGetView<WardSelectController> {
  final WardSelectPageArguments arguments;

  WardSelectPage({
    Key? key,
    required this.arguments,
  }) : super(
          key: key,
          initialController: WardSelectControllerImpl(
            addressRepository: Get.find(),
            notificationService: Get.find(),
            prefectureName: arguments.prefectureName,
          ),
        );

  @override
  Widget build(BuildContext context, WardSelectController controller) {
    return BaseLayout(
      header: AppHeader(
        titleText: tra(LocaleKeys.titlePage_selectCity),
        helpScript: tra(LocaleKeys.helpScript_selectCity),
        hideMenuButton: true,
      ),
      body: _buildBody(controller),
    );
  }

  Widget _buildBody(WardSelectController controller) {
    return Obx(() {
      final bool isLoading = controller.isLoadingAddressList;
      final currentTagData = controller.currentAddress;
      final List<AddressDto> prefectureList = controller.wardList;
      if (isLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      final List<Widget> items = prefectureList.map(
        (address) {
          final bool isSelected = address.tagData.ward == currentTagData?.ward;

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
                address.getCityAndWardName(),
                if (isSelected) tra(LocaleKeys.semTxt_currentSetting),
              ],
              isButton: true,
              child: AppButton(
                borderRadius: 0,
                height: 58,
                color: isSelected ? AppColors.burgundyRed : Colors.transparent,
                onClick: () async {
                  await controller.updateLocation(address);
                  arguments.onDone();
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: AppDimens.paddingMedium,
                    ),
                    Expanded(
                      child: Text(
                        address.getCityAndWardName(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
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
    });
  }
}
