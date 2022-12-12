// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_sqlite.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class ScanCodeSqlEntity extends DataClass
    implements Insertable<ScanCodeSqlEntity> {
  final String id;
  final String title;
  final DateTime date;
  final ScanCodeType codeType;
  final bool isBookmark;
  final String? langKeyWithContentMapJson;
  ScanCodeSqlEntity(
      {required this.id,
      required this.title,
      required this.date,
      required this.codeType,
      required this.isBookmark,
      this.langKeyWithContentMapJson});
  factory ScanCodeSqlEntity.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ScanCodeSqlEntity(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      date: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      codeType: $ScanCodeSqlEntitiesTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}code_type']))!,
      isBookmark: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_bookmark'])!,
      langKeyWithContentMapJson: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}lang_key_with_content_map_json']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['date'] = Variable<DateTime>(date);
    {
      final converter = $ScanCodeSqlEntitiesTable.$converter0;
      map['code_type'] = Variable<int>(converter.mapToSql(codeType)!);
    }
    map['is_bookmark'] = Variable<bool>(isBookmark);
    if (!nullToAbsent || langKeyWithContentMapJson != null) {
      map['lang_key_with_content_map_json'] =
          Variable<String?>(langKeyWithContentMapJson);
    }
    return map;
  }

  ScanCodeSqlEntitiesCompanion toCompanion(bool nullToAbsent) {
    return ScanCodeSqlEntitiesCompanion(
      id: Value(id),
      title: Value(title),
      date: Value(date),
      codeType: Value(codeType),
      isBookmark: Value(isBookmark),
      langKeyWithContentMapJson:
          langKeyWithContentMapJson == null && nullToAbsent
              ? const Value.absent()
              : Value(langKeyWithContentMapJson),
    );
  }

  factory ScanCodeSqlEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScanCodeSqlEntity(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      date: serializer.fromJson<DateTime>(json['date']),
      codeType: serializer.fromJson<ScanCodeType>(json['codeType']),
      isBookmark: serializer.fromJson<bool>(json['isBookmark']),
      langKeyWithContentMapJson:
          serializer.fromJson<String?>(json['langKeyWithContentMapJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'date': serializer.toJson<DateTime>(date),
      'codeType': serializer.toJson<ScanCodeType>(codeType),
      'isBookmark': serializer.toJson<bool>(isBookmark),
      'langKeyWithContentMapJson':
          serializer.toJson<String?>(langKeyWithContentMapJson),
    };
  }

  ScanCodeSqlEntity copyWith(
          {String? id,
          String? title,
          DateTime? date,
          ScanCodeType? codeType,
          bool? isBookmark,
          String? langKeyWithContentMapJson}) =>
      ScanCodeSqlEntity(
        id: id ?? this.id,
        title: title ?? this.title,
        date: date ?? this.date,
        codeType: codeType ?? this.codeType,
        isBookmark: isBookmark ?? this.isBookmark,
        langKeyWithContentMapJson:
            langKeyWithContentMapJson ?? this.langKeyWithContentMapJson,
      );
  @override
  String toString() {
    return (StringBuffer('ScanCodeSqlEntity(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('date: $date, ')
          ..write('codeType: $codeType, ')
          ..write('isBookmark: $isBookmark, ')
          ..write('langKeyWithContentMapJson: $langKeyWithContentMapJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, date, codeType, isBookmark, langKeyWithContentMapJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScanCodeSqlEntity &&
          other.id == this.id &&
          other.title == this.title &&
          other.date == this.date &&
          other.codeType == this.codeType &&
          other.isBookmark == this.isBookmark &&
          other.langKeyWithContentMapJson == this.langKeyWithContentMapJson);
}

class ScanCodeSqlEntitiesCompanion extends UpdateCompanion<ScanCodeSqlEntity> {
  final Value<String> id;
  final Value<String> title;
  final Value<DateTime> date;
  final Value<ScanCodeType> codeType;
  final Value<bool> isBookmark;
  final Value<String?> langKeyWithContentMapJson;
  const ScanCodeSqlEntitiesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.date = const Value.absent(),
    this.codeType = const Value.absent(),
    this.isBookmark = const Value.absent(),
    this.langKeyWithContentMapJson = const Value.absent(),
  });
  ScanCodeSqlEntitiesCompanion.insert({
    required String id,
    required String title,
    required DateTime date,
    required ScanCodeType codeType,
    required bool isBookmark,
    this.langKeyWithContentMapJson = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        date = Value(date),
        codeType = Value(codeType),
        isBookmark = Value(isBookmark);
  static Insertable<ScanCodeSqlEntity> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<DateTime>? date,
    Expression<ScanCodeType>? codeType,
    Expression<bool>? isBookmark,
    Expression<String?>? langKeyWithContentMapJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (date != null) 'date': date,
      if (codeType != null) 'code_type': codeType,
      if (isBookmark != null) 'is_bookmark': isBookmark,
      if (langKeyWithContentMapJson != null)
        'lang_key_with_content_map_json': langKeyWithContentMapJson,
    });
  }

  ScanCodeSqlEntitiesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<DateTime>? date,
      Value<ScanCodeType>? codeType,
      Value<bool>? isBookmark,
      Value<String?>? langKeyWithContentMapJson}) {
    return ScanCodeSqlEntitiesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      codeType: codeType ?? this.codeType,
      isBookmark: isBookmark ?? this.isBookmark,
      langKeyWithContentMapJson:
          langKeyWithContentMapJson ?? this.langKeyWithContentMapJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (codeType.present) {
      final converter = $ScanCodeSqlEntitiesTable.$converter0;
      map['code_type'] = Variable<int>(converter.mapToSql(codeType.value)!);
    }
    if (isBookmark.present) {
      map['is_bookmark'] = Variable<bool>(isBookmark.value);
    }
    if (langKeyWithContentMapJson.present) {
      map['lang_key_with_content_map_json'] =
          Variable<String?>(langKeyWithContentMapJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScanCodeSqlEntitiesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('date: $date, ')
          ..write('codeType: $codeType, ')
          ..write('isBookmark: $isBookmark, ')
          ..write('langKeyWithContentMapJson: $langKeyWithContentMapJson')
          ..write(')'))
        .toString();
  }
}

class $ScanCodeSqlEntitiesTable extends ScanCodeSqlEntities
    with TableInfo<$ScanCodeSqlEntitiesTable, ScanCodeSqlEntity> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ScanCodeSqlEntitiesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime?> date = GeneratedColumn<DateTime?>(
      'date', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _codeTypeMeta = const VerificationMeta('codeType');
  @override
  late final GeneratedColumnWithTypeConverter<ScanCodeType, int?> codeType =
      GeneratedColumn<int?>('code_type', aliasedName, false,
              type: const IntType(), requiredDuringInsert: true)
          .withConverter<ScanCodeType>($ScanCodeSqlEntitiesTable.$converter0);
  final VerificationMeta _isBookmarkMeta = const VerificationMeta('isBookmark');
  @override
  late final GeneratedColumn<bool?> isBookmark = GeneratedColumn<bool?>(
      'is_bookmark', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (is_bookmark IN (0, 1))');
  final VerificationMeta _langKeyWithContentMapJsonMeta =
      const VerificationMeta('langKeyWithContentMapJson');
  @override
  late final GeneratedColumn<String?> langKeyWithContentMapJson =
      GeneratedColumn<String?>(
          'lang_key_with_content_map_json', aliasedName, true,
          type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, date, codeType, isBookmark, langKeyWithContentMapJson];
  @override
  String get aliasedName => _alias ?? 'scan_code_sql_entities';
  @override
  String get actualTableName => 'scan_code_sql_entities';
  @override
  VerificationContext validateIntegrity(Insertable<ScanCodeSqlEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    context.handle(_codeTypeMeta, const VerificationResult.success());
    if (data.containsKey('is_bookmark')) {
      context.handle(
          _isBookmarkMeta,
          isBookmark.isAcceptableOrUnknown(
              data['is_bookmark']!, _isBookmarkMeta));
    } else if (isInserting) {
      context.missing(_isBookmarkMeta);
    }
    if (data.containsKey('lang_key_with_content_map_json')) {
      context.handle(
          _langKeyWithContentMapJsonMeta,
          langKeyWithContentMapJson.isAcceptableOrUnknown(
              data['lang_key_with_content_map_json']!,
              _langKeyWithContentMapJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScanCodeSqlEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ScanCodeSqlEntity.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ScanCodeSqlEntitiesTable createAlias(String alias) {
    return $ScanCodeSqlEntitiesTable(_db, alias);
  }

  static TypeConverter<ScanCodeType, int> $converter0 =
      const EnumIndexConverter<ScanCodeType>(ScanCodeType.values);
}

abstract class _$DatabaseSqlite extends GeneratedDatabase {
  _$DatabaseSqlite(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $ScanCodeSqlEntitiesTable scanCodeSqlEntities =
      $ScanCodeSqlEntitiesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [scanCodeSqlEntities];
}
