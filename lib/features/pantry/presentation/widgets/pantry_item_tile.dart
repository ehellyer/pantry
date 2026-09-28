import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme.dart';
import '../../domain/pantry_item.dart';
import 'pantry_item_sheet.dart';

/// One row. Pure presentation — it takes an item and renders it, nothing else.
///
/// Note it is a StatelessWidget, not a ConsumerWidget: it needs no providers,
/// so it stays trivially testable and reusable.
class PantryItemTile extends StatelessWidget {
  const PantryItemTile({required this.item, super.key});

  final PantryItem item;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final freshness = item.freshnessOn(today);
    final days = item.daysUntilExpiry(today);
    final colors = Theme.of(context).extension<FreshnessColors>()!;

    return ListTile(
      leading: Container(
        width: 4,
        height: 40,
        decoration: BoxDecoration(
          color: colors.forFreshness(freshness),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      title: Text(item.name),
      subtitle: Text(
        '${item.location.name} · ${DateFormat.MMMd().format(item.expiresOn)}',
      ),
      trailing: Text(
        _daysLabel(days),
        style: TextStyle(
          color: colors.forFreshness(freshness),
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () => showPantryItemSheet(context, existing: item),
    );
  }

  /// Human-readable countdown. Presentation logic, so it lives here.
  String _daysLabel(int days) => switch (days) {
        < 0 => 'expired',
        0 => 'today',
        1 => 'tomorrow',
        _ => '${days}d',
      };
}