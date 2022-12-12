part of '../navi_compass_page.dart';

class _Compass extends StatefulWidget {
  final AppLocationStatus locationStatus;
  final bool isLoading;
  final PointDto headingPoint;
  final CoordinateDto? currentCoordinate;
  final double? angleDegree;

  const _Compass({
    Key? key,
    required this.locationStatus,
    required this.isLoading,
    required this.headingPoint,
    required this.currentCoordinate,
    required this.angleDegree,
  }) : super(key: key);

  @override
  __CompassState createState() => __CompassState();
}

class __CompassState extends State<_Compass> {
  late Timer timer;

  @override
  void initState() {
    super.initState();

    // Smooth out the compass, re-render every 16ms to get 60fps
    timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (widget.locationStatus == AppLocationStatus.notAsked) {
      return AppLoading();
    }

    if (widget.locationStatus == AppLocationStatus.denied) {
      return _buildErrorText('Location permission denied');
    }

    if (widget.isLoading) {
      return AppLoading();
    }

    if (widget.angleDegree == null) {
      // TODO handle this
      return AppLoading();
    }

    if (widget.currentCoordinate == null) {
      return _buildErrorText('Unexpected error: Cannot get location');
    }

    final double distanceInMeters = LocationUtils.getDistanceInMeters(
      startCoord: widget.currentCoordinate!,
      endCoord: widget.headingPoint.coordinate,
    );

    final int estimateInMinutes =
        LocationUtils.getEstimateTimeInMinutes(distanceInMeters).toInt();

    final String displayText = tra(LocaleKeys.txt_displayCompassWA, namedArgs: {
      "pointName": widget.headingPoint.pointName,
      "distanceInMeters": distanceInMeters.toStringAsFixed(0),
      "estimateInMinutes": estimateInMinutes.toString()
    });

    return AppSemantics(
      labelList: [displayText],
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF0A97D9),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Text(
                  displayText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                top: -20,
                bottom: -20,
                left: -20,
                right: -20,
                child: Transform.rotate(
                  angle: widget.angleDegree! * math.pi / 180,
                  child: _buildPointer(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointer() {
    return Container(
      child: Column(
        children: [
          // ! Workaround to align the icon
          Transform.rotate(
            angle: -0.85,
            child: Container(
              // ! Workaround to align the icon
              padding: EdgeInsets.only(left: 12),
              child: SvgPicture.asset(
                'assets/images/icons/compass.svg',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorText(String text) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
