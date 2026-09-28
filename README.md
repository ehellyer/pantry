# Pantry

A small Flutter app for tracking what's in your kitchen and what's about to go
off. Items are stored with a location and an expiry date, the list is sorted
most-urgent-first, and each item is color-coded by how long it has left.

This is a **learning project**. The app is deliberately small so that the
interesting parts are the structure and the tooling rather than the feature
count — a real but modest problem, solved properly, as a vehicle for learning
Flutter and Dart end to end.

## Learning goals

**Mapping out the project structure.** Code is organized by *feature* rather
than by kind, so everything about the pantry lives under one folder instead of
being scattered across top-level `models/`, `views/` and `services/`
directories. Inside a feature, the four layers are separated so that
dependencies point in one direction only.

**Building the architecture of the app.** The domain layer defines a
`PantryRepository` interface and knows nothing about SQL; the data layer
implements it with Drift. That seam is what makes the app testable — the widget
tests swap in a forty-line in-memory fake and the UI cannot tell the difference.
State is managed with Riverpod: reads flow through a `StreamProvider` fed by the
database, writes go through a separate command object, and the UI never manually
refreshes after a write.

**Learning the build and test systems of Flutter.** The project uses
`build_runner` for code generation (Drift writes `pantry_database.g.dart` from
the table definitions), `flutter_lints` for static analysis, and both kinds of
test Flutter offers: plain unit tests for the freshness rules and widget tests
that pump a real widget tree.

**Using one codebase to deploy to iOS and Android.** One `lib/` directory, two
platform targets, no platform-specific branching in the app code.

## Project structure

```
lib/
├── main.dart                    ProviderScope + MaterialApp
├── core/
│   └── theme.dart               shared theme
└── features/
    └── pantry/
        ├── domain/              entities and interfaces; no Flutter, no SQL
        │   ├── pantry_item.dart
        │   └── pantry_repository.dart
        ├── data/                persistence; the only place SQL exists
        │   ├── pantry_database.dart
        │   ├── pantry_database.g.dart   (generated — do not edit)
        │   └── drift_pantry_repository.dart
        ├── application/         state and use cases
        │   ├── pantry_providers.dart
        │   └── pantry_filter.dart
        └── presentation/        widgets
            ├── pantry_list_screen.dart
            └── widgets/
```

The dependency rule: `presentation` → `application` → `domain`, and `data` →
`domain`. Nothing points back inward. `domain/pantry_item.dart` imports nothing
at all, which is why its rules are trivial to test.

## Key design decisions

These are the parts worth understanding, and the reason the project exists:

- **Time is a parameter, not a global.** `daysUntilExpiry(today)` takes the
  current date rather than calling `DateTime.now()` internally. That single
  choice makes every freshness rule deterministic and testable.
- **The repository is an interface.** `abstract interface class` (Dart 3) means
  the compiler enforces that it stays a contract. Tests override one provider
  and replace the entire data layer.
- **The domain enum is duplicated in the data layer.** `StorageLocation` and
  `StorageLocationColumn` look redundant. The duplication is the price of
  keeping the domain free of Drift, and it stops a reordered enum from silently
  corrupting stored rows.
- **Entities are immutable.** Mutation goes through `copyWith`, which keeps
  equality honest and lets Flutter make correct rebuild decisions.

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generates *.g.dart
flutter run
```

The generated `pantry_database.g.dart` is required to compile. Before
`build_runner` has run for the first time, the `part` directive in
`pantry_database.dart` will show as an error in your editor — that is expected.

While working on the database schema, leave the generator watching:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Tests

```bash
flutter test                 # everything
flutter test --coverage      # writes coverage/lcov.info
flutter analyze              # static analysis
dart format .                # formatting
```

Two kinds of test, on purpose:

| File | Kind | What it covers |
| --- | --- | --- |
| `test/freshness_test.dart` | unit | expiry boundaries against a fixed date |
| `test/pantry_list_test.dart` | widget | the screen, against a fake repository |

## Platforms

Only the `ios/` target is currently generated. To add Android:

```bash
flutter create --platforms=android .
```

The `.gitignore` already covers the Android build artifacts, so no further
setup is needed once the folder exists.

| Command | Output |
| --- | --- |
| `flutter build ios` | iOS app bundle |
| `flutter build apk` | Android APK |
| `flutter build appbundle` | Android App Bundle, for Play Store upload |

## Stack

| Package | Role |
| --- | --- |
| `flutter_riverpod` | state management and dependency injection |
| `drift` / `drift_flutter` | typed SQLite persistence |
| `sqlite3_flutter_libs` | bundled SQLite binaries |
| `intl` | date formatting |
| `build_runner` / `drift_dev` | code generation |
| `flutter_lints` | analysis rules |

Requires the Dart SDK `^3.13.4`.
