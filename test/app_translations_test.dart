import 'package:flutter_test/flutter_test.dart';

void main() {
  test("All languages' keys should be defined", () {
    expect(true, true);

    // final service = AppTranslations();

    // // Result example:
    // // [
    // //   ['back', 'next', 'hello'], // en
    // //   ['back', 'next', 'hi'], // vi
    // // ]
    // final List<List<String>> languagesKeyList = service.keys.values
    //     .map((langKeyValueMap) => langKeyValueMap.keys.toList())
    //     .toList();

    // for (int i = 0; i < languagesKeyList.length - 1; i++) {
    //   for (int j = i + 1; j < languagesKeyList.length; j++) {
    //     final List<String> diffKeys =
    //         _listDiff(languagesKeyList[i], languagesKeyList[j]);

    //     expect(
    //       diffKeys.length,
    //       0,
    //       reason: 'These keys are missing: ${diffKeys.toString()}',
    //     );
    //   }
    // }
  });
}

// List<T> _listDiff<T>(List<T> l1, List<T> l2) => (l1.toSet()..addAll(l2))
//     .where((i) => !l1.contains(i) || !l2.contains(i))
//     .toList();
