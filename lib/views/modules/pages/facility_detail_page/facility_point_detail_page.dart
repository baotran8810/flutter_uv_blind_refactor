import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/code_info_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_app_dto.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/facility_detail_page/facility_point_detail_page_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/facility_detail_page/facility_point_detail_page_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/facility_point_item.dart';
import 'package:get/get.dart';

class FacilityPointDetailPageArguments {
  final PointAppDto point;

  /// Analytics purpose
  final CodeInfoDto? codeInfo;

  FacilityPointDetailPageArguments({
    required this.point,
    this.codeInfo,
  });
}

class FacilityPointDetailPage
    extends AppGetView<FacilityPointDetailPageController> {
  final FacilityPointDetailPageArguments arguments;

  FacilityPointDetailPage({
    Key? key,
    required this.arguments,
  }) : super(
          key: key,
          initialController: FacilityPointDetailPageControllerImpl(
            analyticsService: Get.find(),
            point: arguments.point,
            codeInfo: arguments.codeInfo,
          ),
        );

  @override
  Widget build(
    BuildContext context,
    FacilityPointDetailPageController controller,
  ) {
    return BaseLayout(
      header: AppHeader(
        titleText: tra(LocaleKeys.titlePage_facilityDetail),
        semanticsTitle: tra(LocaleKeys.semTitlePage_facilityDetail),
        helpScript: tra(LocaleKeys.helpScript_spotDetail),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FacilityPointItem(
              point: arguments.point,
            ),
            _buildActions(
              onPressedCompass: () {
                controller.openNaviCompass();
              },
              onPressedLocation: () {
                controller.openMap();
              },
              onPressedSearch: () {
                controller.openSearch();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions({
    required void Function() onPressedCompass,
    required void Function() onPressedLocation,
    required void Function() onPressedSearch,
  }) {
    return Column(
      children: [
        _buildActionBtn(
          onPressed: onPressedCompass,
          color: Color(0xFFFD6925),
          svgAssetUrl: AppSvgAssets.iconCompass,
          text: tra(LocaleKeys.btn_guideToPoint),
        ),
        _buildActionBtn(
          onPressed: onPressedLocation,
          color: Color(0xFF00689D),
          svgAssetUrl: AppSvgAssets.iconLocationPin,
          text: tra(LocaleKeys.btn_openMapApp),
        ),
        _buildActionBtn(
          onPressed: onPressedSearch,
          color: Color(0xFF4C9F38),
          svgAssetUrl: AppSvgAssets.iconSearch,
          text: tra(LocaleKeys.btn_searchFacilityInWeb),
          isLastItem: true,
        ),
      ],
    );
  }

  Widget _buildActionBtn({
    required void Function() onPressed,
    required Color color,
    required String svgAssetUrl,
    required String text,
    bool isLastItem = false,
  }) {
    final BorderSide divider = BorderSide(
      color: Color(0xFFBBBABA),
    );

    return Material(
      color: Colors.transparent,
      child: AppSemantics(
        labelList: [text],
        isButton: true,
        child: InkWell(
          onTap: onPressed,
          child: Ink(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.paddingNormal,
              vertical: AppDimens.paddingNormal,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: divider,
                bottom: isLastItem ? divider : BorderSide.none,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      svgAssetUrl,
                      width: 32,
                    ),
                  ),
                ),
                SizedBox(width: AppDimens.paddingNormal),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
