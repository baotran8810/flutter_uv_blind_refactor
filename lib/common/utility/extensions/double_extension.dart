extension DoubleExt on double {
  double map({
    required double inputMin,
    required double inputMax,
    required double outputMin,
    required double outputMax,
  }) {
    return (this - inputMin) * (outputMax - outputMin) / (inputMax - inputMin) +
        outputMin;
  }

  double toDoubleAsFixed(int fractionDigits) {
    final numStr = toStringAsFixed(2);
    return double.parse(numStr);
  }
}
