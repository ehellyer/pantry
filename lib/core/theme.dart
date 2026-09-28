import 'package:flutter/material.dart';

import '../features/pantry/domain/pantry_item.dart';

/// Freshness colors, registered on ThemeData so widgets read them from
/// context rather than importing a constants file.
class FreshnessColors extends ThemeExtension<FreshnessColors> {
  const FreshnessColors({
    required this.expired,
    required this.urgent,
    required this.soon,
    required this.fresh,
  });

  final Color expired;
  final Color urgent;
  final Color soon;
  final Color fresh;

  /// Maps a domain value to its color. The switch is exhaustive, so adding a
  /// Freshness case later becomes a compile error here — which is what you want.
  Color forFreshness(Freshness f) => switch (f) {
        Freshness.expired => expired,
        Freshness.urgent => urgent,
        Freshness.soon => soon,
        Freshness.fresh => fresh,
      };

  static const light = FreshnessColors(
    expired: Color(0xFFB3261E),
    urgent: Color(0xFFD97706),
    soon: Color(0xFF0369A1),
    fresh: Color(0xFF15803D),
  );

  @override
  FreshnessColors copyWith({
    Color? expired,
    Color? urgent,
    Color? soon,
    Color? fresh,
  }) =>
      FreshnessColors(
        expired: expired ?? this.expired,
        urgent: urgent ?? this.urgent,
        soon: soon ?? this.soon,
        fresh: fresh ?? this.fresh,
      );

  /// Required by ThemeExtension so Flutter can animate between themes.
  @override
  FreshnessColors lerp(FreshnessColors? other, double t) {
    if (other == null) return this;
    return FreshnessColors(
      expired: Color.lerp(expired, other.expired, t)!,
      urgent: Color.lerp(urgent, other.urgent, t)!,
      soon: Color.lerp(soon, other.soon, t)!,
      fresh: Color.lerp(fresh, other.fresh, t)!,
    );
  }
}

/// The app's ThemeData, with [FreshnessColors] registered.
///
/// Defined once so main() and the widget tests build the same theme. Any
/// widget that reads the extension crashes under a bare MaterialApp, which
/// makes "the app works but the test throws" an easy trap to fall into.
ThemeData get pantryTheme => ThemeData(
      colorSchemeSeed: Colors.teal,
      useMaterial3: true,
      extensions: const [FreshnessColors.light],
    );