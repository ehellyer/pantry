import 'package:drift/drift.dart';

import '../domain/pantry_item.dart';
import '../domain/pantry_repository.dart';
import 'pantry_database.dart';

/// Drift-backed [PantryRepository].
///
/// The only class in the app that knows SQL exists. Its whole job is
/// translating between Drift rows and domain entities.
class DriftPantryRepository implements PantryRepository {
  DriftPantryRepository(this._db);

  final PantryDatabase _db;

  @override
  Stream<List<PantryItem>> watchAll() {
    // Ordering in SQL rather than Dart: the database is better at it, and the
    // stream then arrives pre-sorted on every change.
    final query = _db.select(_db.pantryItemRows)
      ..orderBy([(t) => OrderingTerm.asc(t.expiresOn)]);

    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<PantryItem> save(PantryItem item) async {
    final id = item.id;
    if (id == null) {
      final newId = await _db.into(_db.pantryItemRows).insert(_toInsertable(item));
      return item.copyWith(id: newId);
    }

    await (_db.update(_db.pantryItemRows)..where((t) => t.id.equals(id)))
        .write(_toInsertable(item));
    return item;
  }

  @override
  Future<void> delete(int id) =>
      (_db.delete(_db.pantryItemRows)..where((t) => t.id.equals(id))).go();

  /// Row -> entity. Enum crosses the boundary by index.
  PantryItem _toDomain(PantryItemRow row) => PantryItem(
        id: row.id,
        name: row.name,
        quantity: row.quantity,
        location: StorageLocation.values[row.location.index],
        expiresOn: row.expiresOn,
      );

  /// Entity -> row. `Value.absent()` lets SQLite assign the autoincrement id.
  PantryItemRowsCompanion _toInsertable(PantryItem item) => PantryItemRowsCompanion(
        id: item.id == null ? const Value.absent() : Value(item.id!),
        name: Value(item.name),
        quantity: Value(item.quantity),
        location: Value(StorageLocationColumn.values[item.location.index]),
        expiresOn: Value(item.expiresOn),
      );
}