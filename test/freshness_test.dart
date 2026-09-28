import 'package:flutter_test/flutter_test.dart';
import 'package:pantry/features/pantry/domain/pantry_item.dart';

void main() {
  // A fixed "today" — no dependency on when the suite runs.
  final today = DateTime(2026, 9, 21);

  PantryItem itemExpiring(DateTime on) =>
      PantryItem(id: 1, name: 'Milk', expiresOn: on);

  group('freshnessOn', () {
    test('yesterday is expired', () {
      expect(itemExpiring(DateTime(2026, 9, 20)).freshnessOn(today),
          Freshness.expired);
    });

    test('today is urgent, not expired', () {
      expect(itemExpiring(today).freshnessOn(today), Freshness.urgent);
    });

    test('two days out is urgent, three days out is soon', () {
      expect(itemExpiring(DateTime(2026, 9, 23)).freshnessOn(today),
          Freshness.urgent);
      expect(itemExpiring(DateTime(2026, 9, 24)).freshnessOn(today),
          Freshness.soon);
    });

    test('beyond a week is fresh', () {
      expect(itemExpiring(DateTime(2026, 10, 1)).freshnessOn(today),
          Freshness.fresh);
    });
  });
}