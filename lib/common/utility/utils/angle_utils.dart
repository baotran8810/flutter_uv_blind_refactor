class AngleUtils {
  static int getClockFromDegree(double degree) {
    return (degree % 360) ~/ 30;
  }
}
