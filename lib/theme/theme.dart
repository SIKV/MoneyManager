import 'package:flutter/material.dart';
import 'package:moneymanager/theme/colors.dart';
import 'package:moneymanager/theme/radius.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

enum AppThemeType {
  light, dark
}

abstract class AppTheme {
  AppThemeType get type;
  AppColors get colors;

  ThemeData themeData() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colors.colorScheme,
      navigationBarTheme: const NavigationBarThemeData(
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
      ),
      toggleButtonsTheme: const ToggleButtonsThemeData(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.two)),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: colors.colorScheme.onSurface,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
        bodySmall: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}

class LightAppTheme extends AppTheme {
  @override
  AppThemeType get type => AppThemeType.light;

  @override
  AppColors get colors => LightAppColors();
}

class DarkAppTheme extends AppTheme {
  @override
  AppThemeType get type => AppThemeType.dark;

  @override
  AppColors get colors => DarkAppColors();
}

@riverpod
class AppThemeManager extends _$AppThemeManager {
  AppTheme _theme = LightAppTheme(); // TODO: Change default value.
  AppTheme get theme => _theme;

  @override
  AppTheme build() {
    return _theme;
  }

  void setTheme(AppThemeType type) {
    switch (type) {
      case AppThemeType.light:
        _theme = LightAppTheme();
        break;
      case AppThemeType.dark:
        _theme = DarkAppTheme();
        break;
    }
    ref.invalidateSelf();
  }
}
