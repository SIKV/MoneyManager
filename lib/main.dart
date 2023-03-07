import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/local_preferences.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = LocalPreferences();
  await preferences.load();

  runApp(
    ProviderScope(
      overrides: [
        localPreferencesProvider.overrideWith((ref) => preferences),
      ],
      child: const App(),
    ),
  );
}
