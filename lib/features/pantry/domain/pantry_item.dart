/// Where an item is stored. Drives the filter chips on the list screen.
enum StorageLocation { fridge, freezer, cupboard }

/// How urgent an item is, derived from its expiry date.
///
/// Ordered most-urgent-first so the enum's own `index` can drive sorting.
enum Freshness { expired, urgent, soon, fresh }

/// A single tracked pantry item.
///
/// Immutable. Mutation happens through [copyWith], which keeps equality and
/// hashing honest and makes the widget layer's rebuild decisions correct.
class PantryItem {
  const PantryItem({
    required this.id,
    required this.name,
    required this.expiresOn,
    this.quantity = 1,
    this.location = StorageLocation.cupboard,
  });

  /// Database primary key. Null until the item has been persisted once.
  final int? id;
  final String name;
  final int quantity;
  final StorageLocation location;

  /// Expiry date, normalized to midnight local time so day arithmetic is exact.
  final DateTime expiresOn;

  /// Whole days from [today] until expiry. Negative once the item has expired.
  ///
  /// [today] is a parameter rather than a call to `DateTime.now()` so the rule
  /// is deterministic and testable — the single most important design decision
  /// in this file.
  int daysUntilExpiry(DateTime today) =>
      expiresOn.difference(_atMidnight(today)).inDays;

  /// Urgency bucket for [today]. Thresholds live here, not in the UI.
  Freshness freshnessOn(DateTime today) {
    final days = daysUntilExpiry(today);
    if (days < 0) return Freshness.expired;
    if (days <= 2) return Freshness.urgent;
    if (days <= 7) return Freshness.soon;
    return Freshness.fresh;
  }

  /// Returns a copy with the given fields replaced.
  ///
  /// Note the sentinel-free signature: passing `null` for [id] cannot clear it.
  /// That is deliberate — an id is never unset once assigned.
  PantryItem copyWith({
    int? id,
    String? name,
    int? quantity,
    StorageLocation? location,
    DateTime? expiresOn,
  }) {
    return PantryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      location: location ?? this.location,
      expiresOn: expiresOn ?? this.expiresOn,
    );
  }

  /// A copy with no id, ready to be inserted as a new row.
  ///
  /// [copyWith] cannot express this — passing `null` for [id] means "keep it" —
  /// so restoring a deleted item needs an operation of its own.
  PantryItem asUnsaved() => PantryItem(
        id: null,
        name: name,
        quantity: quantity,
        location: location,
        expiresOn: expiresOn,
      );

  /// Strips the time component so two dates on the same calendar day are equal.
  static DateTime _atMidnight(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  bool operator ==(Object other) =>
      other is PantryItem &&
      other.id == id &&
      other.name == name &&
      other.quantity == quantity &&
      other.location == location &&
      other.expiresOn == expiresOn;

  @override
  int get hashCode => Object.hash(id, name, quantity, location, expiresOn);
}