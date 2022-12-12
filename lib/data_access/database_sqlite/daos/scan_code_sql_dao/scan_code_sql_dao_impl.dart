import 'package:flutter_uv_blind_refactor/data_access/database_sqlite/daos/scan_code_sql_dao/scan_code_sql_dao.dart';
import 'package:flutter_uv_blind_refactor/data_access/database_sqlite/database_sqlite.dart';
import 'package:flutter_uv_blind_refactor/data_access/dtos/scan_code/scan_code_dto.dart';

class ScanCodeSqlDaoImpl implements ScanCodeSqlDao {
  final DatabaseSqlite _databaseSqlite;

  ScanCodeSqlDaoImpl({
    required DatabaseSqlite databaseSqlite,
  }) : _databaseSqlite = databaseSqlite;

  @override
  Future<void> addScanCodeList(List<ScanCodeDto> scanCodeList) async {
    final entryList = scanCodeList.map((scanCode) {
      return scanCode.toSqlCompanion();
    }).toList();

    await _databaseSqlite.addScanCodeList(entryList);
  }

  @override
  Future<void> addScanCode(ScanCodeDto scanCode) async {
    await _databaseSqlite.addScanCode(scanCode.toSqlCompanion());
  }

  @override
  Future<void> updateScanCode(String id, ScanCodeDto scanCode) async {
    await _databaseSqlite.updateScanCode(
      id,
      scanCode.toSqlCompanion(),
    );
  }

  @override
  Future<void> deleteScanCode(String id) async {
    await _databaseSqlite.deleteScanCode(id);
  }
}
