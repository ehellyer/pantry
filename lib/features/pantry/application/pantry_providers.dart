import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/drift_pantry_repository.dart';
import '../data/pantry_database.dart';
import '../domain/pantry_item.dart';
import '../domain/pantry_repository.dart';

/// The database connection, created once and closed with the scope.
final pantryDatabaseProvider = Provider<PantryDatabase>((ref) {
  final db = PantryDatabase();
  ref.onDispose(db.close); // ties the connection's life to the provider's
  return db;
});

/// The repository, typed as the *interface*.
///
/// This is the dependency-inversion seam: tests override this provider with a
/// fake and nothing downstream changes or knows.
final pantryRepositoryProvider = Provider<PantryRepository>(
  (ref) => DriftPantryRepository(ref.watch(pantryDatabaseProvider)),
);

/// The live item list.
///
/// StreamProvider wraps the repository's stream in AsyncValue, so the UI gets
/// loading, error and data states without writing any of that plumbing.
final pantryItemsProvider = StreamProvider<List<PantryItem>>(
  (ref) => ref.watch(pantryRepositoryProvider).watchAll(),
);

/// Write operations, as a small command object.
///
/// Separate from [pantryItemsProvider] on purpose: reads are a stream the
/// database owns, writes are commands. Keeping them apart means the UI never
/// has to manually refresh after a write — the stream does it.
///
/// A plain class rather than a Notifier: there is no state to hold. A
/// `Notifier<void>` publishes `void` as its state, so `ref.read(provider)`
/// yields nothing callable and every call site has to reach for `.notifier`.
/// Taking the repository through the constructor also states the dependency
/// outright instead of hiding it behind a `ref` lookup.
class PantryActions {
  const PantryActions(this._repository);

  final PantryRepository _repository;

  Future<void> save(PantryItem item) => _repository.save(item);

  Future<void> delete(int id) => _repository.delete(id);
}

final pantryActionsProvider = Provider<PantryActions>(
  (ref) => PantryActions(ref.watch(pantryRepositoryProvider)),
);