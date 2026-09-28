import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/pantry_item.dart';
import 'pantry_providers.dart';

/// The active location filter. Null means "show everything".
class PantryFilter extends Notifier<StorageLocation?> {
  @override
  StorageLocation? build() => null;

  /// Tapping the active chip clears the filter — a toggle, not a radio group.
  void toggle(StorageLocation location) =>
      state = state == location ? null : location;
}

final pantryFilterProvider =
    NotifierProvider<PantryFilter, StorageLocation?>(PantryFilter.new);

/// The list the UI actually renders.
///
/// A derived provider: it recomputes only when the items or the filter change,
/// and the widget rebuilds only when the *result* differs. Doing this filtering
/// inside `build` instead would redo the work on every unrelated rebuild.
final visibleItemsProvider = Provider<List<PantryItem>>((ref) {
  final items = ref.watch(pantryItemsProvider).value ?? const [];
  final filter = ref.watch(pantryFilterProvider);

  if (filter == null) return items;
  return items.where((item) => item.location == filter).toList();
});