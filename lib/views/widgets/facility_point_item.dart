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
          name: '公共機関',
          svgAssetUrl: AppSvgAssets.icInstitution,
        );
      case PointCategoryType.accommodation:
        return _CategoryViewData(
          name: '宿泊施設',
          svgAssetUrl: AppSvgAssets.icAccomodation,
        );
      case PointCategoryType.transportation:
        return _CategoryViewData(
          name: '交通機関',
          svgAssetUrl: AppSvgAssets.icTransportation,
        );
      case PointCategoryType.shrine:
        return _CategoryViewData(
          name: '神社仏閣',
          svgAssetUrl: AppSvgAssets.icTemple,
        );
      case PointCategoryType.restaurant:
        return _CategoryViewData(
          name: '飲食店',
          svgAssetUrl: AppSvgAssets.icRestaurant,
        );
      case PointCategoryType.shopping:
        return _CategoryViewData(
          name: 'ショッピング',
          svgAssetUrl: AppSvgAssets.icShopping,
        );
      case PointCategoryType.medical:
        return _CategoryViewData(
          name: '医療機関',
          svgAssetUrl: AppSvgAssets.icCourselist,
        );
      case PointCategoryType.sightseeing:
        return _CategoryViewData(
          name: '観光名所',
          svgAssetUrl: AppSvgAssets.icSightseeing,
        );
      case PointCategoryType.government:
        return _CategoryViewData(
          name: '役所',
          svgAssetUrl: AppSvgAssets.icGovernmentOffice,
        );
      case PointCategoryType.school:
        return _CategoryViewData(
          name: '学校',
          svgAssetUrl: AppSvgAssets.icSchool,
        );
      case PointCategoryType.convenienceStore:
        return _CategoryViewData(
          name: 'コンビニエンスストア',
          svgAssetUrl: AppSvgAssets.icConvenienceStore,
        );
      case PointCategoryType.gasStation:
        return _CategoryViewData(
          name: 'ガソリンスタンド',
          svgAssetUrl: AppSvgAssets.icGasStation,
        );
      case PointCategoryType.postBox:
        return _CategoryViewData(
          name: 'ポスト',
          svgAssetUrl: AppSvgAssets.icPostbox,
        );
      case PointCategoryType.museum:
        return _CategoryViewData(
          name: '美術館・博物館',
          svgAssetUrl: AppSvgAssets.icMuseum,
        );
      case PointCategoryType.scenicSites:
        return _CategoryViewData(
          name: '名所・旧跡',
          svgAssetUrl: AppSvgAssets.icScenicSites,
        );
      case PointCategoryType.naturalScenery:
        return _CategoryViewData(
          name: '自然・風景',
          svgAssetUrl: AppSvgAssets.icNaturalScenery,
        );
      case PointCategoryType.workshop:
        return _CategoryViewData(
          name: '工房・体験施設',
          svgAssetUrl: AppSvgAssets.icWorkshop,
        );
      case PointCategoryType.church:
        return _CategoryViewData(
          name: '教会',
          svgAssetUrl: AppSvgAssets.icChurch,
        );
      case PointCategoryType.evacShelter:
        return _CategoryViewData(
          name: '避難場所',
          svgAssetUrl: AppSvgAssets.icEvacuation,
        );
      case PointCategoryType.shelter:
        return _CategoryViewData(
          name: '避難所',
          svgAssetUrl: AppSvgAssets.icEvacuationcenter,
        );
      case PointCategoryType.publicPhone:
        return _CategoryViewData(
          name: '公衆電話',
          svgAssetUrl: AppSvgAssets.publicPhone,
        );
      case PointCategoryType.specialPhone:
        return _CategoryViewData(
          name: '災害用公衆電話',
          svgAssetUrl: AppSvgAssets.specialPhone,
        );
      case PointCategoryType.waterStation:
        return _CategoryViewData(
          name: '給水所（給水拠点）',
          svgAssetUrl: AppSvgAssets.icWaterStation,
        );
      case PointCategoryType.publicRestroom:
        return _CategoryViewData(
          name: '公共トイレ',
          svgAssetUrl: AppSvgAssets.icPublicRestroom,
        );
      case PointCategoryType.tempStayFacility:
        return _CategoryViewData(
          name: '帰宅困難者滞在施設',
          svgAssetUrl: AppSvgAssets.icTemporaryStayFacilities,
        );
      case PointCategoryType.shortTermEva:
        return _CategoryViewData(
          name: '一時避難場所',
          svgAssetUrl: AppSvgAssets.icShortTermEvacuationShelters,
        );
      case PointCategoryType.socialWelfareInstitutionEva:
        return _CategoryViewData(
          name: '福祉避難所',
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
          name: '津波避難施設',
          svgAssetUrl: AppSvgAssets.icTsunamiEvacuationFacilitiy,
        );
      case PointCategoryType.policeStation:
        return _CategoryViewData(
          name: '警察署（交番、派出所）',
          svgAssetUrl: AppSvgAssets.icPoliceStation,
        );
      case PointCategoryType.fireStation:
        return _CategoryViewData(
          name: '消防署（屯所）',
          svgAssetUrl: AppSvgAssets.icFireStation,
        );
      case PointCategoryType.hospital:
        return _CategoryViewData(
          name: '病院',
          svgAssetUrl: AppSvgAssets.icHospital,
        );
      case PointCategoryType.disasterEmergencyHospital:
        return _CategoryViewData(
          name: '災害時救急病院',
          svgAssetUrl: AppSvgAssets.icDisasterEmergencyHospital,
        );
      case PointCategoryType.emergencyHelicopter:
        return _CategoryViewData(
          name: '災害時用ヘリポート',
          svgAssetUrl: AppSvgAssets.icEmergencyHelicopterLandingFacilities,
        );
      case PointCategoryType.fireHydrant:
        return _CategoryViewData(
          name: '消火栓',
          svgAssetUrl: AppSvgAssets.icFireHydrant,
        );
      case PointCategoryType.stadium:
        return _CategoryViewData(
          name: '競技場',
          svgAssetUrl: AppSvgAssets.icStadium,
        );
    }
  }
}
