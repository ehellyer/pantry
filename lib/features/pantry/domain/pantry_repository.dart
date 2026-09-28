import 'pantry_item.dart';

/// Storage boundary for pantry items.
///
/// `abstract interface class` (Dart 3) means this type can only be implemented,
/// never extended or instantiated — the compiler enforces that it stays a
/// contract. The domain layer owns it; the data layer satisfies it.
abstract interface class PantryRepository {
  /// Emits the full item list, and again on every change.
  ///
  /// A Stream rather than a Future because the UI should react to writes
  /// without the caller re-fetching.
  Stream<List<PantryItem>> watchAll();

  /// Inserts [item] when its id is null, otherwise updates in place.
  /// Returns the stored item, with an id assigned on insert.
  Future<PantryItem> save(PantryItem item);

  Future<void> delete(int id);
}