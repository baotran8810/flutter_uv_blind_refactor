part of '../file_list_page.dart';

class _CodeListSection extends StatelessWidget {
  final List<ScanCodeDto> scanCodeList;
  final void Function(ScanCodeDto) onPressedItem;

  const _CodeListSection({
    Key? key,
    required this.scanCodeList,
    required this.onPressedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return scanCodeList.isEmpty
        ? Center(
            child: AppSemantics(
              labelList: [tra(LocaleKeys.txt_noSavedFile)],
              child: Text(
                tra(LocaleKeys.txt_noSavedFile),
                style: AppStyles.headerText,
              ),
            ),
          )
        : ScanCodeListView(
            scanCodeList: scanCodeList,
            onPressedItem: (scanCode) {
              onPressedItem(scanCode);
            },
          );
  }
}
