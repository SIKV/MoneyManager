import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/app.dart';
import 'package:moneymanager/data/providers.dart';
import 'package:moneymanager/local_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_startup.g.dart';

@Riverpod(keepAlive: true)
Future<void> appStartup(AppStartupRef ref) async {
  final localPreferences = ref.watch(localPreferencesProvider);
  await localPreferences.load();

  if (localPreferences.isFirstLaunch()) {
    final categoriesRepository = await ref.watch(categoriesRepositoryProvider);
    await categoriesRepository.initWithDefaultsIfEmpty();

    localPreferences.setFirstLaunch();
  }
}

class AppStartup extends ConsumerWidget {
  const AppStartup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);

    return appStartupState.when(
      loading: () => const _AppStartupLoading(),
      error: (_, __) => const _AppStartupError(),
      data: (_) => const App(),
    );
  }
}

class _AppStartupLoading extends StatelessWidget {
  const _AppStartupLoading();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // TODO: Implement loading screen.
        ),
      ),
    );
  }
}

class _AppStartupError extends StatelessWidget {
  const _AppStartupError();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(), // TODO: Implement error screen.
    );
  }
}
