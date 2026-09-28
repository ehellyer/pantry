import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

// Points at the file the generator will create. It does not exist yet — your
// editor will flag this line until build_runner has run once. Expected.
part 'pantry_database.g.dart';

/// Drift table definition for pantry items.
///
/// Column names in SQLite are derived from the getter names (snake_cased).
/// Note this is a *persistence* shape, not the domain entity — the enum is
/// stored as an int, which the domain layer should never have to know.
class PantryItemRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get quantity => integer().withDefault(const Constant(1))();

  /// StorageLocation stored by index. `intEnum` generates the conversion.
  IntColumn get location => intEnum<StorageLocationColumn>()();

  DateTimeColumn get expiresOn => dateTime()();
}

/// Mirror of the domain's StorageLocation, owned by the data layer.
///
/// Duplicating the enum looks redundant, and it is the price of keeping the
/// domain free of Drift. It also means reordering the domain enum cannot
/// silently corrupt stored rows.
enum StorageLocationColumn { fridge, freezer, cupboard }

@DriftDatabase(tables: [PantryItemRows])
class PantryDatabase extends _$PantryDatabase {
  PantryDatabase() : super(driftDatabase(name: 'pantry'));

  /// Bump this and add a migration step for any schema change after launch.
  @override
  int get schemaVersion => 1;
}
