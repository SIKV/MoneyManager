import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/preferences.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = Preferences();
  await preferences.load();

  runApp(
    ProviderScope(
      overrides: [
        preferencesProvider.overrideWith((ref) => preferences),
      ],
      child: const App(),
    ),
  );
}
