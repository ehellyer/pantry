import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'features/pantry/presentation/pantry_list_screen.dart';

void main() {
  // ProviderScope holds the state of every provider. One, at the root.
  runApp(const ProviderScope(child: PantryApp()));
}

class PantryApp extends StatelessWidget {
  const PantryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pantry',
      theme: pantryTheme,
      home: const PantryListScreen(),
    );
  }
}