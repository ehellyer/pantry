import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/pantry_providers.dart';
import 'widgets/pantry_item_sheet.dart';
import 'widgets/pantry_item_tile.dart';

/// The app's only screen.
///
/// ConsumerWidget is StatelessWidget plus a `ref`. Use it instead of
/// StatelessWidget anywhere you need providers.
class PantryListScreen extends ConsumerWidget {
  const PantryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(pantryItemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pantry')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showPantryItemSheet(context),
        child: const Icon(Icons.add),
      ),
      // AsyncValue.when forces you to handle all three states. There is no
      // way to accidentally render a half-loaded list.
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load: $error')),
        data: (items) => items.isEmpty
            ? const _EmptyPantry()
            : ListView.builder(
                // builder, not ListView(children:) — only visible rows are built.
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Dismissible(
                    // A stable key per item. Without it, dismissing one row
                    // animates the wrong one away — the classic Flutter list bug.
                    key: ValueKey(item.id),
                    direction: DismissDirection.endToStart,
                    background: const ColoredBox(
                      color: Colors.red,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                    ),
                    onDismissed: (_) {
                      // read, not watch — we are in a callback.
                      ref.read(pantryActionsProvider).delete(item.id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Deleted ${item.name}'),
                          action: SnackBarAction(
                            label: 'Undo',
                            // copyWith() would keep the id, and save() would
                            // then update a row that no longer exists.
                            onPressed: () => ref
                                .read(pantryActionsProvider)
                                .save(item.asUnsaved()),
                          ),
                        ),
                      );
                    },
                    child: PantryItemTile(item: item),
                  );
                },
              ),
      ),
    );
  }
}

/// Shown when there is nothing to track. An empty list is a state worth
/// designing, not an accident.
class _EmptyPantry extends StatelessWidget {
  const _EmptyPantry();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.kitchen_outlined,
              size: 64, color: Theme.of(context).disabledColor),
          const SizedBox(height: 16),
          const Text('Nothing tracked yet'),
          const SizedBox(height: 4),
          Text('Tap + to add your first item',
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}