import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/local_preferences.dart';

import 'app_startup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final localPreferences = container.read(localPreferencesProvider);

  await localPreferences.load();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const AppStartup(),
    ),
  );
}
