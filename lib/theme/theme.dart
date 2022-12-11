import 'package:flutter/material.dart';
import 'package:moneymanager/theme/colors.dart';
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
      colorScheme: colors.colorScheme,
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
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
