import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/point_app_dto.dart';

abstract class FacilityMainPageController {
  List<PointAppDto> get pointList;
  bool get isLoading;
  PointsSortCriteria? get sortCriteria;

  bool get isBookmark;
  Future<void> setBookmark();
  Future<void> deleteCode();

  void toggleSortBy(PointsSortCriteria criteria);
  void goToPointDetail(PointAppDto point);
}

enum PointsSortCriteria {
  category,
  distance,
}

// enum SortOrder { ascend, descend }

// extension SortOrderExt on SortOrder {
//   SortOrder getOpposite() {
//     switch (this) {
//       case SortOrder.ascend:
//         return SortOrder.descend;
//       case SortOrder.descend:
//         return SortOrder.ascend;
//     }
//   }
// }
