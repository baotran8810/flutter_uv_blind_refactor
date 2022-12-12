import 'dart:io';

import 'package:app_group_directory/app_group_directory.dart';
import 'package:drift/native.dart';
import 'package:flutter_uv_blind_refactor/common/utility/utils.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_sqlite/daos/scan_code_sql_dao/scan_code_sql_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_sqlite/daos/scan_code_sql_dao/scan_code_sql_dao_impl.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_sqlite/database_sqlite.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

const String _kDatabaseFile = 'db.sqlite';

Future<NativeDatabase> _openDatabase() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();

  final Directory? dbDirectory;

  if (Platform.isIOS) {
    // Use group directory on iOS to share data between extensions (Siri ext)
    final String groupName = 'group.${packageInfo.packageName}';
    dbDirectory = await AppGroupDirectory.getAppGroupDirectory(groupName);
  } else {
    // Just a fallback on Android, but we currently don't need to use
    // this DB on Android
    dbDirectory = await getApplicationDocumentsDirectory();
  }

  if (dbDirectory == null) {
    throw Exception(
      'CUSTOM: Something went wrong trying to get appGroupDirectory',
    );
  }

  final file = File(join(dbDirectory.path, _kDatabaseFile));
  return NativeDatabase(file);
}

Future<void> setupSqlite() async {
  final db = await _openDatabase();

  putPermanent<DatabaseSqlite>(
    DatabaseSqlite(db),
  );

  _setupDaos();
}

void _setupDaos() {
  putPermanent<ScanCodeSqlDao>(
    ScanCodeSqlDaoImpl(
      databaseSqlite: Get.find(),
    ),
  );
}
