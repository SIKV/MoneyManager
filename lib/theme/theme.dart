import 'package:flutter/material.dart';
import 'package:moneymanager/theme/colors.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

enum AppTheme {
  light, dark
}

@riverpod
class AppThemeManager extends _$AppThemeManager {
  AppTheme _theme = AppTheme.light; // TODO Change default value.
  AppTheme get theme => _theme;

  @override
  AppTheme build() {
    return _theme;
  }

  void setTheme(AppTheme theme) {
    _theme = theme;
    ref.invalidateSelf();
  }
}

extension GetThemeData on AppTheme {
  ThemeData themeData() {
    Brightness brightness = this == AppTheme.light
        ? Brightness.light : Brightness.dark;

    AppColors colors = this == AppTheme.light
        ? AppColorsLight() :  AppColorsDark();

    return ThemeData(
      brightness: brightness,
      primaryColor: colors.primary,
      canvasColor: colors.canvas,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.bottomSheetBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
      ),
    );
  }
}
