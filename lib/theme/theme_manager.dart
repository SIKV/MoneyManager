import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/local_preferences.dart';
import 'package:moneymanager/theme/colors.dart';
import 'package:moneymanager/theme/theme.dart';

final appThemeManagerProvider = NotifierProvider<AppThemeManager, AppTheme>(() =>
    AppThemeManager()
);

class AppThemeManager extends Notifier<AppTheme> with WidgetsBindingObserver {

  @override
  AppTheme build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));

    switch (getType()) {
      case AppThemeType.light:
        return LightAppTheme();
      case AppThemeType.dark:
        return DarkAppTheme();
    }
  }

  AppColors getColors() {
    switch (getType()) {
      case AppThemeType.light:
        return LightAppColors();
      case AppThemeType.dark:
        return DarkAppColors();
    }
  }

  AppThemeType getType() {
    final theme = ref.read(localPreferencesProvider).theme;

    if (theme != null) {
      return theme;
    } else {
      // Get system theme.
      final brightness = SchedulerBinding.instance
          .platformDispatcher
          .platformBrightness;

      switch (brightness) {
        case Brightness.dark:
          return AppThemeType.dark;
        case Brightness.light:
          return AppThemeType.light;
      }
    }
  }

  ThemeMode getThemeMode() {
    return switch (ref.read(localPreferencesProvider).theme) {
      null => ThemeMode.system,
      AppThemeType.light => ThemeMode.light,
      AppThemeType.dark => ThemeMode.dark,
    };
  }

  void setThemeMode(ThemeMode themeMode) {
    final AppThemeType? theme = switch (themeMode) {
      ThemeMode.system => null,
      ThemeMode.light => AppThemeType.light,
      ThemeMode.dark => AppThemeType.dark,
    };

    ref.read(localPreferencesProvider)
        .setTheme(theme);

    ref.invalidateSelf();
  }

  @override
  void didChangePlatformBrightness() {
    if (getThemeMode() == ThemeMode.system) {
      ref.invalidateSelf();
    }
  }
}
