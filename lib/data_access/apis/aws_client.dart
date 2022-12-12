import 'dart:typed_data';

import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';

abstract class AwsClient {
  Future<Uint8List> getPollyFile({
    required String sentence,
    required String langKey,
    required Gender gender,
  });
}
