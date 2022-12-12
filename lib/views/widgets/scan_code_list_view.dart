import 'package:flutter/material.dart';
import 'package:flutter_uv_blind_refactor/common/theme/assets.dart';
import 'package:flutter_uv_blind_refactor/common/theme/colors.dart';
import 'package:flutter_uv_blind_refactor/common/theme/dimens.dart';
import 'package:flutter_uv_blind_refactor/common/translations/locale_keys.g.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/datetime_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils/localization_utils.dart';
import 'package:flutter_uv_blind_refactor/common/utility/view_utils/scan_code_view_utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_listview/app_listview.dart';
import 'package:flutter_uv_blind_refactor/views/modules/widgets/app_semantics/app_semantics.dart';

class ScanCodeListView extends StatelessWidget {
  final List<ScanCodeDto> scanCodeList;
  final void Function(ScanCodeDto scanCode)? onPressedItem;
  final Widget Function(ScanCodeDto scanCode)? itemBottomBuilder;

  const ScanCodeListView({
    Key? key,
    required this.scanCodeList,
    this.onPressedItem,
    this.itemBottomBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppListView(
      itemCount: scanCodeList.length,
      itemBuilder: (context, index) {
        final scanCode = scanCodeList[index];

        return _ScanCodeListItem(
          scanCode: scanCode,
          onPressed: onPressedItem != null
              ? () {
                  onPressedItem!(scanCode);
                }
              : null,
          bottomWidget: itemBottomBuilder?.call(scanCode),
        );
      },
    );
  }
}

class _ScanCodeListItem extends StatelessWidget {
  final ScanCodeDto scanCode;
  final void Function()? onPressed;
  final Widget? bottomWidget;

  const _ScanCodeListItem({
    Key? key,
    required this.scanCode,
    this.onPressed,
    this.bottomWidget,
  }) : super(key: key);

  void _onPressedScanCode(ScanCodeDto scanCode) {
    onPressed != null
        ? onPressed!()
        : ScanCodeViewUtils.goToScanCodePage([scanCode]);
  }

  @override
  Widget build(BuildContext context) {
    final itemSemText = tra(
      LocaleKeys.semBtn_fileItemWA,
      namedArgs: {
        'codeType': scanCode.codeType.getDisplayName(),
        'fileName': scanCode.name,
        'createdDate': DateTimeUtils.formatDateTime(scanCode.createdDate),
      },
    );

    // Use GestureDetector instead of InkWell because InkWell's `excludeFromSemantics` doesn't work somehow
    return GestureDetector(
      excludeFromSemantics: true,
      onTap: () {
        _onPressedScanCode(scanCode);
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.paddingNormal,
              vertical: AppDimens.paddingNormal,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFBBBABA),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSemantics(
                  labelList: [itemSemText],
                  isButton: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          scanCode.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimens.paddingTiny),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppSemantics(
                            labelList: [scanCode.codeType.getDisplayName()],
                            child: Container(
                              width: 90,
                              padding: EdgeInsets.symmetric(
                                vertical: AppDimens.paddingTiny,
                              ),
                              decoration: BoxDecoration(
                                color: _getCodeTypeColor(scanCode.codeType),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  scanCode.codeType.getDisplayName(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: AppSemantics(
                              labelList: [
                                DateTimeUtils.formatDateTime(
                                    scanCode.createdDate)
                              ],
                              child: Text(
                                DateTimeUtils.formatDateTime(
                                    scanCode.createdDate),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFA5A5A5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (bottomWidget != null) bottomWidget!,
              ],
            ),
          ),
          if (scanCode.isBookmark)
            Positioned(
              top: -1,
              right: AppDimens.paddingNormal,
              child: Image.asset(
                AppAssets.iconBookMark,
              ),
            ),
        ],
      ),
    );
  }

  Color _getCodeTypeColor(ScanCodeType codeType) {
    switch (codeType) {
      case ScanCodeType.navi:
        return AppColors.burgundyRed;
      case ScanCodeType.facility:
        return Color(0xFF26BDE2);
      case ScanCodeType.doc:
        return Color(0xFF3F7E44);
    }
  }
}
