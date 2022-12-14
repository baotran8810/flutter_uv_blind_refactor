import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/angle_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/location_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_app_dto.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_dto.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';

class FacilityPointItem extends StatelessWidget {
  final PointAppDto point;
  final void Function()? onPressed;

  const FacilityPointItem({
    Key? key,
    required this.point,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String firstCategoryName = point.categoryList.isNotEmpty
        ? point.categoryList[0].categoryType._getViewData().name
        : '';

    final String displayClockDegree = point.angleDegree != null
        ? AngleUtils.getClockFromDegree(point.angleDegree!).toString()
        : 'N/A';

    final String displayDistance =
        point.distanceToCurLocation?.toStringAsFixed(0) ?? 'N/A';

    final String displayEstimate = point.distanceToCurLocation != null
        ? LocationUtils.getEstimateTimeInMinutes(point.distanceToCurLocation!)
            .toStringAsFixed(0)
        : 'N/A';

    final String semLabel = tra(
      LocaleKeys.semBtn_facilityPointItemWA,
      namedArgs: {
        'pointName': point.pointName,
        'categoryName': firstCategoryName,
        'clockDegree': displayClockDegree,
        'distance': displayDistance,
        'estimate': displayEstimate,
      },
    );

    final String displayDesc = tra(
      LocaleKeys.txt_pointNaviDescWA,
      namedArgs: {
        'clockDegree': displayClockDegree,
        'distance': displayDistance,
        'estimate': displayEstimate,
      },
    );

    return Material(
      color: Colors.transparent,
      child: AppSemantics(
        labelList: [semLabel],
        isButton: onPressed != null,
        child: InkWell(
          onTap: onPressed,
          child: Ink(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.paddingNormal,
              vertical: AppDimens.paddingNormal,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  point.pointName,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: AppDimens.paddingNormal),
                if (point.categoryList.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(bottom: AppDimens.paddingNormal),
                    child: Wrap(
                      spacing: AppDimens.paddingNormal,
                      runSpacing: AppDimens.paddingTiny,
                      children: [
                        ...point.categoryList.map((category) {
                          final index = point.categoryList.indexOf(category);

                          return _buildCategoryIcon(
                            category: category,
                            isShowName: index == 0,
                          );
                        }),
                      ],
                    ),
                  ),
                Text(
                  displayDesc,
                  style: TextStyle(
                    color: Color(0xFF2D2C2C),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon({
    required PointCategoryDto category,
    bool isShowName = false,
  }) {
    return AppSemantics(
      labelList: [category.categoryType._getViewData().name],
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Center(
                child: SvgPicture.asset(
                  category.categoryType._getViewData().svgAssetUrl,
                  width: 32,
                ),
              ),
            ),
            if (isShowName)
              Container(
                margin: EdgeInsets.only(left: AppDimens.paddingTiny),
                child: Text(
                  category.categoryType._getViewData().name,
                  style: TextStyle(
                    color: Color(0xFF2D2C2C),
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryViewData {
  final String name;
  final String svgAssetUrl;

  const _CategoryViewData({
    required this.name,
    required this.svgAssetUrl,
  });
}

extension _PointCategoryTypeExt on PointCategoryType {
  _CategoryViewData _getViewData() {
    switch (this) {
      case PointCategoryType.institution:
        return _CategoryViewData(
          name: '????????????',
          svgAssetUrl: AppSvgAssets.icInstitution,
        );
      case PointCategoryType.accommodation:
        return _CategoryViewData(
          name: '????????????',
          svgAssetUrl: AppSvgAssets.icAccomodation,
        );
      case PointCategoryType.transportation:
        return _CategoryViewData(
          name: '????????????',
          svgAssetUrl: AppSvgAssets.icTransportation,
        );
      case PointCategoryType.shrine:
        return _CategoryViewData(
          name: '????????????',
          svgAssetUrl: AppSvgAssets.icTemple,
        );
      case PointCategoryType.restaurant:
        return _CategoryViewData(
          name: '?????????',
          svgAssetUrl: AppSvgAssets.icRestaurant,
        );
      case PointCategoryType.shopping:
        return _CategoryViewData(
          name: '??????????????????',
          svgAssetUrl: AppSvgAssets.icShopping,
        );
      case PointCategoryType.medical:
        return _CategoryViewData(
          name: '????????????',
          svgAssetUrl: AppSvgAssets.icCourselist,
        );
      case PointCategoryType.sightseeing:
        return _CategoryViewData(
          name: '????????????',
          svgAssetUrl: AppSvgAssets.icSightseeing,
        );
      case PointCategoryType.government:
        return _CategoryViewData(
          name: '??????',
          svgAssetUrl: AppSvgAssets.icGovernmentOffice,
        );
      case PointCategoryType.school:
        return _CategoryViewData(
          name: '??????',
          svgAssetUrl: AppSvgAssets.icSchool,
        );
      case PointCategoryType.convenienceStore:
        return _CategoryViewData(
          name: '??????????????????????????????',
          svgAssetUrl: AppSvgAssets.icConvenienceStore,
        );
      case PointCategoryType.gasStation:
        return _CategoryViewData(
          name: '????????????????????????',
          svgAssetUrl: AppSvgAssets.icGasStation,
        );
      case PointCategoryType.postBox:
        return _CategoryViewData(
          name: '?????????',
          svgAssetUrl: AppSvgAssets.icPostbox,
        );
      case PointCategoryType.museum:
        return _CategoryViewData(
          name: '?????????????????????',
          svgAssetUrl: AppSvgAssets.icMuseum,
        );
      case PointCategoryType.scenicSites:
        return _CategoryViewData(
          name: '???????????????',
          svgAssetUrl: AppSvgAssets.icScenicSites,
        );
      case PointCategoryType.naturalScenery:
        return _CategoryViewData(
          name: '???????????????',
          svgAssetUrl: AppSvgAssets.icNaturalScenery,
        );
      case PointCategoryType.workshop:
        return _CategoryViewData(
          name: '?????????????????????',
          svgAssetUrl: AppSvgAssets.icWorkshop,
        );
      case PointCategoryType.church:
        return _CategoryViewData(
          name: '??????',
          svgAssetUrl: AppSvgAssets.icChurch,
        );
      case PointCategoryType.evacShelter:
        return _CategoryViewData(
          name: '????????????',
          svgAssetUrl: AppSvgAssets.icEvacuation,
        );
      case PointCategoryType.shelter:
        return _CategoryViewData(
          name: '?????????',
          svgAssetUrl: AppSvgAssets.icEvacuationcenter,
        );
      case PointCategoryType.publicPhone:
        return _CategoryViewData(
          name: '????????????',
          svgAssetUrl: AppSvgAssets.publicPhone,
        );
      case PointCategoryType.specialPhone:
        return _CategoryViewData(
          name: '?????????????????????',
          svgAssetUrl: AppSvgAssets.specialPhone,
        );
      case PointCategoryType.waterStation:
        return _CategoryViewData(
          name: '???????????????????????????',
          svgAssetUrl: AppSvgAssets.icWaterStation,
        );
      case PointCategoryType.publicRestroom:
        return _CategoryViewData(
          name: '???????????????',
          svgAssetUrl: AppSvgAssets.icPublicRestroom,
        );
      case PointCategoryType.tempStayFacility:
        return _CategoryViewData(
          name: '???????????????????????????',
          svgAssetUrl: AppSvgAssets.icTemporaryStayFacilities,
        );
      case PointCategoryType.shortTermEva:
        return _CategoryViewData(
          name: '??????????????????',
          svgAssetUrl: AppSvgAssets.icShortTermEvacuationShelters,
        );
      case PointCategoryType.socialWelfareInstitutionEva:
        return _CategoryViewData(
          name: '???????????????',
          svgAssetUrl:
              AppSvgAssets.icSocialWelfareInstitutionEvacuationShelters,
        );
      case PointCategoryType.aed:
        return _CategoryViewData(
          name: 'AED',
          svgAssetUrl: AppSvgAssets.icAed,
        );
      case PointCategoryType.tsunamiEva:
        return _CategoryViewData(
          name: '??????????????????',
          svgAssetUrl: AppSvgAssets.icTsunamiEvacuationFacilitiy,
        );
      case PointCategoryType.policeStation:
        return _CategoryViewData(
          name: '?????????????????????????????????',
          svgAssetUrl: AppSvgAssets.icPoliceStation,
        );
      case PointCategoryType.fireStation:
        return _CategoryViewData(
          name: '?????????????????????',
          svgAssetUrl: AppSvgAssets.icFireStation,
        );
      case PointCategoryType.hospital:
        return _CategoryViewData(
          name: '??????',
          svgAssetUrl: AppSvgAssets.icHospital,
        );
      case PointCategoryType.disasterEmergencyHospital:
        return _CategoryViewData(
          name: '?????????????????????',
          svgAssetUrl: AppSvgAssets.icDisasterEmergencyHospital,
        );
      case PointCategoryType.emergencyHelicopter:
        return _CategoryViewData(
          name: '???????????????????????????',
          svgAssetUrl: AppSvgAssets.icEmergencyHelicopterLandingFacilities,
        );
      case PointCategoryType.fireHydrant:
        return _CategoryViewData(
          name: '?????????',
          svgAssetUrl: AppSvgAssets.icFireHydrant,
        );
      case PointCategoryType.stadium:
        return _CategoryViewData(
          name: '?????????',
          svgAssetUrl: AppSvgAssets.icStadium,
        );
    }
  }
}
