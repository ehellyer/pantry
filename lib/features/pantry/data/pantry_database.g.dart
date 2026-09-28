// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pantry_database.dart';

// ignore_for_file: type=lint
class $PantryItemRowsTable extends PantryItemRows
    with TableInfo<$PantryItemRowsTable, PantryItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PantryItemRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  late final GeneratedColumnWithTypeConverter<StorageLocationColumn, int>
  location =
      GeneratedColumn<int>(
        'location',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<StorageLocationColumn>(
        $PantryItemRowsTable.$converterlocation,
      );
  static const VerificationMeta _expiresOnMeta = const VerificationMeta(
    'expiresOn',
  );
  @override
  late final GeneratedColumn<DateTime> expiresOn = GeneratedColumn<DateTime>(
    'expires_on',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    quantity,
    location,
    expiresOn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pantry_item_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<PantryItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('expires_on')) {
      context.handle(
        _expiresOnMeta,
        expiresOn.isAcceptableOrUnknown(data['expires_on']!, _expiresOnMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresOnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PantryItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PantryItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      location: $PantryItemRowsTable.$converterlocation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}location'],
        )!,
      ),
      expiresOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_on'],
      )!,
    );
  }

  @override
  $PantryItemRowsTable createAlias(String alias) {
    return $PantryItemRowsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StorageLocationColumn, int, int>
  $converterlocation = const EnumIndexConverter<StorageLocationColumn>(
    StorageLocationColumn.values,
  );
}

class PantryItemRow extends DataClass implements Insertable<PantryItemRow> {
  final int id;
  final String name;
  final int quantity;

  /// StorageLocation stored by index. `intEnum` generates the conversion.
  final StorageLocationColumn location;
  final DateTime expiresOn;
  const PantryItemRow({
    required this.id,
    required this.name,
    required this.quantity,
    required this.location,
    required this.expiresOn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<int>(quantity);
    {
      map['location'] = Variable<int>(
        $PantryItemRowsTable.$converterlocation.toSql(location),
      );
    }
    map['expires_on'] = Variable<DateTime>(expiresOn);
    return map;
  }

  PantryItemRowsCompanion toCompanion(bool nullToAbsent) {
    return PantryItemRowsCompanion(
      id: Value(id),
      name: Value(name),
      quantity: Value(quantity),
      location: Value(location),
      expiresOn: Value(expiresOn),
    );
  }

  factory PantryItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PantryItemRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<int>(json['quantity']),
      location: $PantryItemRowsTable.$converterlocation.fromJson(
        serializer.fromJson<int>(json['location']),
      ),
      expiresOn: serializer.fromJson<DateTime>(json['expiresOn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<int>(quantity),
      'location': serializer.toJson<int>(
        $PantryItemRowsTable.$converterlocation.toJson(location),
      ),
      'expiresOn': serializer.toJson<DateTime>(expiresOn),
    };
  }

  PantryItemRow copyWith({
    int? id,
    String? name,
    int? quantity,
    StorageLocationColumn? location,
    DateTime? expiresOn,
  }) => PantryItemRow(
    id: id ?? this.id,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    location: location ?? this.location,
    expiresOn: expiresOn ?? this.expiresOn,
  );
  PantryItemRow copyWithCompanion(PantryItemRowsCompanion data) {
    return PantryItemRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      location: data.location.present ? data.location.value : this.location,
      expiresOn: data.expiresOn.present ? data.expiresOn.value : this.expiresOn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PantryItemRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('location: $location, ')
          ..write('expiresOn: $expiresOn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, quantity, location, expiresOn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PantryItemRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.location == this.location &&
          other.expiresOn == this.expiresOn);
}

class PantryItemRowsCompanion extends UpdateCompanion<PantryItemRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> quantity;
  final Value<StorageLocationColumn> location;
  final Value<DateTime> expiresOn;
  const PantryItemRowsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.location = const Value.absent(),
    this.expiresOn = const Value.absent(),
  });
  PantryItemRowsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.quantity = const Value.absent(),
    required StorageLocationColumn location,
    required DateTime expiresOn,
  }) : name = Value(name),
       location = Value(location),
       expiresOn = Value(expiresOn);
  static Insertable<PantryItemRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? quantity,
    Expression<int>? location,
    Expression<DateTime>? expiresOn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (location != null) 'location': location,
      if (expiresOn != null) 'expires_on': expiresOn,
    });
  }

  PantryItemRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? quantity,
    Value<StorageLocationColumn>? location,
    Value<DateTime>? expiresOn,
  }) {
    return PantryItemRowsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      location: location ?? this.location,
      expiresOn: expiresOn ?? this.expiresOn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (location.present) {
      map['location'] = Variable<int>(
        $PantryItemRowsTable.$converterlocation.toSql(location.value),
      );
    }
    if (expiresOn.present) {
      map['expires_on'] = Variable<DateTime>(expiresOn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PantryItemRowsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('location: $location, ')
          ..write('expiresOn: $expiresOn')
          ..write(')'))
        .toString();
  }
}

abstract class _$PantryDatabase extends GeneratedDatabase {
  _$PantryDatabase(QueryExecutor e) : super(e);
  $PantryDatabaseManager get managers => $PantryDatabaseManager(this);
  late final $PantryItemRowsTable pantryItemRows = $PantryItemRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [pantryItemRows];
}

typedef $$PantryItemRowsTableCreateCompanionBuilder =
    PantryItemRowsCompanion Function({
      Value<int> id,
      required String name,
      Value<int> quantity,
      required StorageLocationColumn location,
      required DateTime expiresOn,
    });
typedef $$PantryItemRowsTableUpdateCompanionBuilder =
    PantryItemRowsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> quantity,
      Value<StorageLocationColumn> location,
      Value<DateTime> expiresOn,
    });

class $$PantryItemRowsTableFilterComposer
    extends Composer<_$PantryDatabase, $PantryItemRowsTable> {
  $$PantryItemRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    StorageLocationColumn,
    StorageLocationColumn,
    int
  >
  get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get expiresOn => $composableBuilder(
    column: $table.expiresOn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PantryItemRowsTableOrderingComposer
    extends Composer<_$PantryDatabase, $PantryItemRowsTable> {
  $$PantryItemRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresOn => $composableBuilder(
    column: $table.expiresOn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PantryItemRowsTableAnnotationComposer
    extends Composer<_$PantryDatabase, $PantryItemRowsTable> {
  $$PantryItemRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StorageLocationColumn, int> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresOn =>
      $composableBuilder(column: $table.expiresOn, builder: (column) => column);
}

class $$PantryItemRowsTableTableManager
    extends
        RootTableManager<
          _$PantryDatabase,
          $PantryItemRowsTable,
          PantryItemRow,
          $$PantryItemRowsTableFilterComposer,
          $$PantryItemRowsTableOrderingComposer,
          $$PantryItemRowsTableAnnotationComposer,
          $$PantryItemRowsTableCreateCompanionBuilder,
          $$PantryItemRowsTableUpdateCompanionBuilder,
          (
            PantryItemRow,
            BaseReferences<
              _$PantryDatabase,
              $PantryItemRowsTable,
              PantryItemRow
            >,
          ),
          PantryItemRow,
          PrefetchHooks Function()
        > {
  $$PantryItemRowsTableTableManager(
    _$PantryDatabase db,
    $PantryItemRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PantryItemRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PantryItemRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PantryItemRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<StorageLocationColumn> location = const Value.absent(),
                Value<DateTime> expiresOn = const Value.absent(),
              }) => PantryItemRowsCompanion(
                id: id,
                name: name,
                quantity: quantity,
                location: location,
                expiresOn: expiresOn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> quantity = const Value.absent(),
                required StorageLocationColumn location,
                required DateTime expiresOn,
              }) => PantryItemRowsCompanion.insert(
                id: id,
                name: name,
                quantity: quantity,
                location: location,
                expiresOn: expiresOn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PantryItemRowsTable, PantryItemRow>(table),
                  BaseReferences<
                    _$PantryDatabase,
                    $PantryItemRowsTable,
                    PantryItemRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PantryItemRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$PantryDatabase,
      $PantryItemRowsTable,
      PantryItemRow,
      $$PantryItemRowsTableFilterComposer,
      $$PantryItemRowsTableOrderingComposer,
      $$PantryItemRowsTableAnnotationComposer,
      $$PantryItemRowsTableCreateCompanionBuilder,
      $$PantryItemRowsTableUpdateCompanionBuilder,
      (
        PantryItemRow,
        BaseReferences<_$PantryDatabase, $PantryItemRowsTable, PantryItemRow>,
      ),
      PantryItemRow,
      PrefetchHooks Function()
    >;

class $PantryDatabaseManager {
  final _$PantryDatabase _db;
  $PantryDatabaseManager(this._db);
  $$PantryItemRowsTableTableManager get pantryItemRows =>
      $$PantryItemRowsTableTableManager(_db, _db.pantryItemRows);
}
