import 'dart:io';

import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/base_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/entities/scan_code/scan_code_entity.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_hive/hive_constants.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class AppHive {
  AppHive();

  Future<void> init() async {
    final Directory appFolder = await getApplicationDocumentsDirectory();

    final String hivePath = '${appFolder.path}/hive';

    // * Uncomment to clear database
    // == Delete db
    // final Directory hiveFolder = Directory(hivePath);
    // if (hiveFolder.existsSync()) {
    //   print('Successfully clearing Hive database');
    //   hiveFolder.deleteSync(recursive: true);
    // }
    // == End delete db

    Hive.init(hivePath);

    _registerAdapters();
    HiveBoxMap.registerMiscAdapters();
    await _initBoxes();
  }

  Box<T> getBox<T extends BaseEntity>() {
    final hiveInfo = HiveBoxMap.hiveBoxMap[T];

    if (hiveInfo == null) {
      throw Exception('Hive type ${T.toString()} is missing from hiveBoxMap');
    }

    return Hive.box<T>(hiveInfo.boxName);
  }

  Box<T> getCodeBox<T extends ScanCodeEntity>() {
    final hiveInfo = HiveBoxMap.hiveBoxMap[T];

    if (hiveInfo == null) {
      throw Exception('Hive type ${T.toString()} is missing from hiveBoxMap');
    }

    return Hive.box<T>(hiveInfo.boxName);
  }

  // currentTypeId = 0
  Future<void> _initBoxes() async {
    print('Hive Box init.');

    for (final key in HiveBoxMap.hiveBoxMap.keys) {
      final hiveInfo = HiveBoxMap.hiveBoxMap[key];

      if (hiveInfo == null) {
        throw Exception(
          'Hive type ${key.toString()} is missing from hiveBoxMap',
        );
      }

      await hiveInfo.openBoxFunction();
    }
  }

  void _registerAdapters() {
    for (final key in HiveBoxMap.hiveBoxMap.keys) {
      final hiveInfo = HiveBoxMap.hiveBoxMap[key];

      if (hiveInfo == null) {
        throw Exception(
          'Hive type ${key.toString()} is missing from hiveBoxMap',
        );
      }

      hiveInfo.registerAdapterFunction();
    }
  }
}
