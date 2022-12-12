import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_uv_blind_refactor/common/utility/enums.dart';

part 'database_sqlite.g.dart';

/// This table is for Siri intent to search through files
@DataClassName('ScanCodeSqlEntity')
class ScanCodeSqlEntities extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get codeType => intEnum<ScanCodeType>()();
  BoolColumn get isBookmark => boolean()();
  TextColumn get langKeyWithContentMapJson => text().nullable()();

  @override
  Set<Column>? get primaryKey => {id};
}

@DriftDatabase(tables: [ScanCodeSqlEntities])
class DatabaseSqlite extends _$DatabaseSqlite {
  final NativeDatabase database;

  // we tell the database where to store the data with this constructor
  DatabaseSqlite(this.database) : super(database);

  // Pump this up when database changed
  @override
  int get schemaVersion => 1;

  Future<void> addScanCodeList(
    List<ScanCodeSqlEntitiesCompanion> entryList,
  ) async {
    await batch((batch) {
      batch.insertAll(
        scanCodeSqlEntities,
        entryList.map((entry) => entry).toList(),
      );
    });
  }

  Future<int> addScanCode(ScanCodeSqlEntitiesCompanion entry) async {
    return await into(scanCodeSqlEntities).insert(entry);
  }

  /// Return the amount of rows affected
  Future<int> updateScanCode(
    String id,
    ScanCodeSqlEntitiesCompanion entry,
  ) async {
    return await (update(scanCodeSqlEntities)
          ..where(
            (entity) => entity.id.equals(id),
          ))
        .write(entry);
  }

  Future<int> deleteScanCode(String id) async {
    return await (delete(scanCodeSqlEntities)
          ..where(
            (entity) => entity.id.equals(id),
          ))
        .go();
  }
}
