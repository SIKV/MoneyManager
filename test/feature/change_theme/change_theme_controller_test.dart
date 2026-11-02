import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moneymanager/feature/change_theme/change_theme_controller.dart';
import 'package:moneymanager/local_preferences.dart';
import 'package:moneymanager/theme/theme.dart';
import 'package:moneymanager/theme/theme_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalPreferences localPreferences;

  Future<ProviderContainer> createContainer(Map<String, Object> savedPreferences) async {
    SharedPreferences.setMockInitialValues(savedPreferences);
    localPreferences = LocalPreferences();
    await localPreferences.load();

    final container = ProviderContainer(overrides: [
      localPreferencesProvider.overrideWithValue(localPreferences),
    ]);
    addTearDown(container.dispose);

    container.listen(changeThemeControllerProvider, (_, __) { });
    await container.read(changeThemeControllerProvider.future);

    return container;
  }

  testWidgets('Match Device is selected by default and uses the system theme', (tester) async {
    // GIVEN
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    // WHEN
    final container = await createContainer({});

    // THEN
    final state = await container.read(changeThemeControllerProvider.future);
    expect(state.currentThemeMode, ThemeMode.system);
    expect(container.read(appThemeManagerProvider).type, AppThemeType.dark);
  });

  testWidgets('The theme follows system brightness changes when Match Device is selected', (tester) async {
    // GIVEN
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    final container = await createContainer({});

    // WHEN
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pump(Duration.zero);

    // THEN
    expect(container.read(appThemeManagerProvider).type, AppThemeType.dark);
  });

  testWidgets('changeThemeMode(dark) keeps the dark theme when the system turns light', (tester) async {
    // GIVEN
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    final container = await createContainer({});

    // WHEN
    container.read(changeThemeControllerProvider.notifier).changeThemeMode(ThemeMode.dark);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pump(Duration.zero);

    // THEN
    final state = await container.read(changeThemeControllerProvider.future);
    expect(state.currentThemeMode, ThemeMode.dark);
    expect(container.read(appThemeManagerProvider).type, AppThemeType.dark);
    expect(localPreferences.theme, AppThemeType.dark);
  });

  testWidgets('changeThemeMode(light) turns the dark theme off', (tester) async {
    // GIVEN
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    final container = await createContainer({});

    // WHEN
    container.read(changeThemeControllerProvider.notifier).changeThemeMode(ThemeMode.light);
    await tester.pump(Duration.zero);

    // THEN
    final state = await container.read(changeThemeControllerProvider.future);
    expect(state.currentThemeMode, ThemeMode.light);
    expect(container.read(appThemeManagerProvider).type, AppThemeType.light);
    expect(localPreferences.theme, AppThemeType.light);
  });

  testWidgets('changeThemeMode(system) drops the saved theme and uses the system theme', (tester) async {
    // GIVEN
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    final container = await createContainer({'theme': AppThemeType.dark.id});

    // WHEN
    container.read(changeThemeControllerProvider.notifier).changeThemeMode(ThemeMode.system);
    await tester.pump(Duration.zero);

    // THEN
    final state = await container.read(changeThemeControllerProvider.future);
    expect(state.currentThemeMode, ThemeMode.system);
    expect(container.read(appThemeManagerProvider).type, AppThemeType.light);
    expect(localPreferences.theme, isNull);
  });
}
