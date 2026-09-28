import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pantry/core/theme.dart';
import 'package:pantry/features/pantry/application/pantry_providers.dart';
import 'package:pantry/features/pantry/domain/pantry_item.dart';
import 'package:pantry/features/pantry/domain/pantry_repository.dart';
import 'package:pantry/features/pantry/presentation/pantry_list_screen.dart';

/// In-memory repository. No database, no Drift, no async delay.
///
/// This class is the payoff for Phase 1's interface: forty lines of test
/// double, and the screen cannot tell the difference.
class FakePantryRepository implements PantryRepository {
  FakePantryRepository(this._items);

  final List<PantryItem> _items;

  @override
  Stream<List<PantryItem>> watchAll() => Stream.value(_items);

  @override
  Future<PantryItem> save(PantryItem item) async => item;

  @override
  Future<void> delete(int id) async {}
}

void main() {
  testWidgets('shows items from the repository', (tester) async {
    final items = [
      PantryItem(id: 1, name: 'Milk', expiresOn: DateTime(2026, 9, 25)),
      PantryItem(id: 2, name: 'Eggs', expiresOn: DateTime(2026, 10, 5)),
    ];

    await tester.pumpWidget(
      ProviderScope(
        // One override swaps the entire data layer.
        overrides: [
          pantryRepositoryProvider
              .overrideWithValue(FakePantryRepository(items)),
        ],
        child: MaterialApp(theme: pantryTheme, home: const PantryListScreen()),
      ),
    );

    // pumpWidget renders one frame; the stream resolves on the next.
    await tester.pump();

    expect(find.text('Milk'), findsOneWidget);
    expect(find.text('Eggs'), findsOneWidget);
  });

  testWidgets('shows the empty state with no items', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pantryRepositoryProvider
              .overrideWithValue(FakePantryRepository([])),
        ],
        child: MaterialApp(theme: pantryTheme, home: const PantryListScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Nothing tracked yet'), findsOneWidget);
  });
}