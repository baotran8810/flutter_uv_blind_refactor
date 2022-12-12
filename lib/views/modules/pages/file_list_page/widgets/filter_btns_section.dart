part of '../file_list_page.dart';

class _FilterBtnsSection extends StatelessWidget {
  final FileFilter? selectedFilter;
  final void Function(FileFilter) onPressedFilter;

  const _FilterBtnsSection({
    Key? key,
    required this.selectedFilter,
    required this.onPressedFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...FileFilter.values.map((filter) {
            return _buildBtn(filter);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBtn(FileFilter filter) {
    final _ActionData actionData = _getActionData(filter);
    final bool isNotActive = selectedFilter != null && selectedFilter != filter;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 200),
        tween: Tween(end: isNotActive ? 0.4 : 1),
        builder: (context, opacityValue, child) {
          return Opacity(
            opacity: opacityValue,
            child: child,
          );
        },
        child: AppSemantics(
          labelList: [actionData.semanticLabel],
          isButton: true,
          child: AppInkwell(
            onPressed: () {
              onPressedFilter(filter);
            },
            width: 40,
            height: 40,
            borderRadius: BorderRadius.circular(4),
            decoration: BoxDecoration(
              color: actionData.color,
            ),
            child: Center(
              child: Image.asset(
                actionData.imgAsset,
                height: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _ActionData _getActionData(FileFilter filter) {
    switch (filter) {
      case FileFilter.doc:
        return _ActionData(
          color: Color(0xFF3F7E44),
          imgAsset: AppAssets.iconDocument,
          semanticLabel: tra(LocaleKeys.semBtn_docFilter),
        );
      case FileFilter.navi:
        return _ActionData(
          color: Color(0xFFA21942),
          imgAsset: AppAssets.iconRoad,
          semanticLabel: tra(LocaleKeys.semBtn_naviFilter),
        );
      case FileFilter.facility:
        return _ActionData(
          color: Color(0xFF0A97D9),
          imgAsset: AppAssets.iconPin,
          semanticLabel: tra(LocaleKeys.semBtn_facilityFilter),
        );
      case FileFilter.bookmark:
        return _ActionData(
          color: Color(0xFFFD9D24),
          imgAsset: AppAssets.iconStar,
          semanticLabel: tra(LocaleKeys.semBtn_bookmarkFilter),
        );
    }
  }
}

class _ActionData {
  final Color color;
  final String imgAsset;
  final String semanticLabel;

  _ActionData({
    required this.color,
    required this.imgAsset,
    required this.semanticLabel,
  });
}
