abstract class SettingScanPageController {
  Future<void> selectColor(int x);
  Future<void> selectBorderLevel(int x);
  int get selectedBorderLevelIndex;
  int get selectedColorIndex;
}
