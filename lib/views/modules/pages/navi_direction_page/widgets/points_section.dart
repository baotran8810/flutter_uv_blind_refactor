part of '../navi_direction_page.dart';

class _PointsSection extends StatelessWidget {
  final AppLocationStatus locationStatus;
  final List<PointDto> pointList;
  final CoordinateDto startCoordinate;
  final void Function(PointDto point) onPressedPoint;

  const _PointsSection({
    Key? key,
    required this.locationStatus,
    required this.pointList,
    required this.startCoordinate,
    required this.onPressedPoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.paddingNormal,
        vertical: 38,
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        SizedBox(height: 21),
        _buildPointBox(
          color: Color(0xFFDD1367),
          titleText: tra(LocaleKeys.txt_currentLocation),
        ),
        ...pointList.map((point) {
          final int index = pointList.indexOf(point);

          final CoordinateDto prevCoord =
              index == 0 ? startCoordinate : pointList[index - 1].coordinate;

          final bool isLastItem = index == pointList.length - 1;

          return _buildPoint(
              color: !isLastItem ? Color(0xFF00689D) : Color(0xFFDD1367),
              titleText: point.pointName,
              infoText: point.pointInfo,
              prevCoord: prevCoord,
              currentCoord: point.coordinate,
              isShowArrow: !isLastItem,
              onPressed: () {
                onPressedPoint(point);
              });
        }).toList(),
      ],
    );
  }

  Widget _buildHeader() {
    final String titleText = tra(LocaleKeys.txt_directions);
    final String descriptionText = tra(LocaleKeys.txt_tapPointToStartNavi);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSemantics(
          labelList: [titleText],
          child: Text(
            titleText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        AppSemantics(
          labelList: [descriptionText],
          child: Text(
            descriptionText,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  /// Point includes:
  /// - a Description above
  /// - a CLICKABLE pointBox
  Widget _buildPoint({
    required Color color,
    required String titleText,
    String? infoText,
    required CoordinateDto prevCoord,
    required CoordinateDto currentCoord,
    required void Function() onPressed,
    bool isShowArrow = true,
  }) {
    final double angleDegree = LocationUtils.getBearingDegree(
      startCoord: prevCoord,
      endCoord: currentCoord,
    );
    final int angleClock = AngleUtils.getClockFromDegree(angleDegree);

    final double distanceInMeters = LocationUtils.getDistanceInMeters(
      startCoord: prevCoord,
      endCoord: currentCoord,
    );

    final String estimateInMinutesStr =
        LocationUtils.getEstimateTimeInMinutes(distanceInMeters)
            .toStringAsFixed(0);

    final String descriptionText = tra(
      LocaleKeys.txt_pointNaviDescWA,
      namedArgs: {
        'clockDegree': angleClock.toString(),
        'distance': distanceInMeters.toStringAsFixed(0),
        'estimate': estimateInMinutesStr,
      },
    );

    final String readSentence =
        '$titleText ${infoText != null ? '\n$infoText' : ""} ${'\n$descriptionText'}';

    return AppSemantics(
      labelList: [readSentence],
      isButton: true,
      child: Container(
        margin: EdgeInsets.only(top: 8),
        child: GestureDetector(
          onTap: onPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: AppDimens.paddingNormal),
                child: Text(
                  descriptionText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              _buildPointBox(
                color: color,
                titleText: titleText,
                infoText: infoText,
                isShowArrow: isShowArrow,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointBox({
    required Color color,
    required String titleText,
    String? infoText,
    bool isShowArrow = true,
  }) {
    final String readSentence =
        titleText + (infoText != null ? '\n$infoText' : '');

    return AppSemantics(
      labelList: [readSentence],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    titleText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              if (infoText != null && infoText.trim() != '')
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Tooltip(
                        message: infoText,
                        child: Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (isShowArrow)
            Transform.translate(
              offset: Offset(0, -4),
              child: Center(
                child: ClipPath(
                  clipper: _CustomTriangleClipper(),
                  child: Container(
                    width: 32,
                    height: 25,
                    color: color,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CustomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
