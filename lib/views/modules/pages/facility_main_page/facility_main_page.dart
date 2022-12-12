import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/facility_scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_app_dto.dart';
import 'package:flutter_uv_blind_refactor/views/miscs/app_getview/app_getview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/facility_main_page/facility_main_page_controller.dart';
import 'package:flutter_uv_blind_refactor/views/modules/pages/facility_main_page/facility_main_page_controller_impl.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_header/app_header.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_button_new.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/app_shimmer.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/base_layout.dart';
import 'package:flutter_uv_blind_refactor/views/widgets/facility_point_item.dart';
import 'package:get/get.dart';

class FacilityMainPageArguments {
  final FacilityScanCodeDto facilityScanCode;

  FacilityMainPageArguments({
    required this.facilityScanCode,
  });
}

class FacilityMainPage extends AppGetView<FacilityMainPageController> {
  final FacilityMainPageArguments arguments;

  FacilityMainPage({
    Key? key,
    required this.arguments,
  }) : super(
          key: key,
          initialController: FacilityMainPageControllerImpl(
            locationService: Get.find(),
            facilityScanCode: arguments.facilityScanCode,
            scanCodeRepository: Get.find(),
          ),
        );

  @override
  Widget build(BuildContext context, FacilityMainPageController controller) {
    return BaseLayout(
      header: Obx(() {
        final isBookmark = controller.isBookmark;
        return AppHeader(
          titleText: tra(LocaleKeys.titlePage_facilityMain),
          semanticsTitle: tra(LocaleKeys.semTitlePage_facilityMain),
          helpScript: tra(LocaleKeys.helpScript_spotList),
          bottomChild: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BottomActions(
                actionInfoList: [
                  BottomActionInfo(
                    semanticText: !isBookmark
                        ? tra(LocaleKeys.semBtn_fileBookmark)
                        : tra(LocaleKeys.semBtn_fileUnbookmark),
                    color: Color(0xFFFD9D24),
                    iconImgAsset:
                        !isBookmark ? AppAssets.iconStar : AppAssets.iconUnStar,
                    onPressed: () {
                      controller.setBookmark();
                    },
                  ),
                  BottomActionInfo(
                    imageSize: 40,
                    color: Colors.transparent,
                    semanticText: tra(LocaleKeys.semBtn_fileDelete),
                    onPressed: () {
                      controller.deleteCode();
                    },
                    iconImgAsset: AppAssets.iconDelete,
                  ),
                ],
              )
            ],
          ),
        );
      }),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(
              () {
                final currentSortCriteria = controller.sortCriteria;

                return _HeaderSection(
                  titleText: arguments.facilityScanCode.name,
                  currentSortCriteria: currentSortCriteria,
                  onPressedSort: (criteria) {
                    controller.toggleSortBy(criteria);
                  },
                );
              },
            ),
            Obx(
              () {
                final bool isLoading = controller.isLoading;
                final List<PointAppDto> pointList = controller.pointList;

                if (isLoading) {
                  return _ShimmerListView();
                }

                return _PointListView(
                  pointList: pointList,
                  onPressedPoint: (PointAppDto point) {
                    controller.goToPointDetail(point);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final String titleText;
  final PointsSortCriteria? currentSortCriteria;
  final void Function(PointsSortCriteria criteria) onPressedSort;

  const _HeaderSection({
    Key? key,
    required this.titleText,
    required this.currentSortCriteria,
    required this.onPressedSort,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.paddingNormal,
            ),
            child: AppSemantics(
              labelList: [titleText],
              child: Text(
                titleText,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(height: AppDimens.paddingNormal),
          _buildSortActions(),
        ],
      ),
    );
  }

  Widget _buildSortActions() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.paddingNormal,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildActionBtn(
              sortCriteria: PointsSortCriteria.category,
              color: Color(0xFF00689D),
              svgAssetUrl: AppSvgAssets.iconSortCategory,
              text: tra(LocaleKeys.btn_facilitySortCategory),
              semText: tra(LocaleKeys.semBtn_facilitySortCategory),
            ),
          ),
          SizedBox(width: AppDimens.paddingNormal),
          Expanded(
            child: _buildActionBtn(
              sortCriteria: PointsSortCriteria.distance,
              color: Color(0xFFA21942),
              svgAssetUrl: AppSvgAssets.iconSortLocation,
              text: tra(LocaleKeys.btn_facilitySortDistance),
              semText: tra(LocaleKeys.semBtn_facilitySortDistance),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn({
    required PointsSortCriteria sortCriteria,
    required Color color,
    required String svgAssetUrl,
    required String text,
    required String semText,
  }) {
    final bool isNotActive =
        currentSortCriteria != null && currentSortCriteria != sortCriteria;

    return Opacity(
      opacity: isNotActive ? 0.5 : 1,
      child: AppButtonNew(
        onPressed: () {
          onPressedSort(sortCriteria);
        },
        semanticLabel: semText,
        height: 75,
        btnColor: color,
        child: Column(
          children: [
            SvgPicture.asset(
              svgAssetUrl,
              color: Colors.white,
              width: 36,
              height: 36,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PointListView extends StatelessWidget {
  final List<PointAppDto> pointList;
  final void Function(PointAppDto point) onPressedPoint;

  const _PointListView({
    Key? key,
    required this.pointList,
    required this.onPressedPoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      separatorBuilder: (_, __) {
        return Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFBBBABA),
        );
      },
      itemCount: pointList.length,
      itemBuilder: (context, index) {
        final PointAppDto point = pointList[index];

        return FacilityPointItem(
          point: point,
          onPressed: () {
            onPressedPoint(point);
          },
        );
      },
    );
  }
}

class _ShimmerListView extends StatelessWidget {
  const _ShimmerListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (_, __) {
          return Divider(
            height: 1,
            thickness: 1,
          );
        },
        itemBuilder: (_, __) {
          return _buildFakeItem();
        },
      ),
    );
  }

  Widget _buildFakeItem() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.paddingNormal,
        vertical: AppDimens.paddingNormal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFakeItemText(
            text: 'aaaaaaaaaaaaaaa',
            fontSize: 16,
          ),
          SizedBox(height: AppDimens.paddingSmall),
          Wrap(
            spacing: AppDimens.paddingNormal,
            runSpacing: AppDimens.paddingTiny,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    child: CircleAvatar(backgroundColor: Colors.white),
                  ),
                  SizedBox(width: AppDimens.paddingTiny),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      'aaaaaaa',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppDimens.paddingSmall),
          _buildFakeItemText(
            text: 'aaaaaaaaaaaaaaaaaaaaaaaaaaa',
            fontSize: 14,
          ),
        ],
      ),
    );
  }

  Widget _buildFakeItemText({
    required String text,
    required double fontSize,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
    );
  }
}
