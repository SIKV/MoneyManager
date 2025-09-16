import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/local_preferences.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app_startup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final localPreferences = container.read(localPreferencesProvider);

  await localPreferences.load();

  const sentryDsn = String.fromEnvironment('SENTRY_DSN', defaultValue: '');

  if (sentryDsn.isEmpty) {
    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const AppStartup(),
      ),
    );
  } else {
    await SentryFlutter.init((options) {
      options.dsn = sentryDsn;
      options.sendDefaultPii = true;
    }, appRunner: () =>
        runApp(
          SentryWidget(
            child: UncontrolledProviderScope(
              container: container,
              child: const AppStartup(),
            ),
          ),
        ),
    );
  }
}
