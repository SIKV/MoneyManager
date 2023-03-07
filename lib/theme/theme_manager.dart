import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/local_preferences.dart';
import 'package:moneymanager/theme/colors.dart';
import 'package:moneymanager/theme/theme.dart';

final appThemeManagerProvider = NotifierProvider<AppThemeManager, AppTheme>(() =>
    AppThemeManager()
);

class AppThemeManager extends Notifier<AppTheme> {

  @override
  AppTheme build() {
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

  void setTheme(AppThemeType? theme) {
    ref.read(localPreferencesProvider)
        .setTheme(theme);

    ref.invalidateSelf();
  }
}
