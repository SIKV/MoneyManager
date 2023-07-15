import 'package:flutter/material.dart';
import 'package:moneymanager/theme/colors.dart';

enum AppThemeType {
  light(0),
  dark(1);

  const AppThemeType(this.id);

  final int id;
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
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: colors.colorScheme.onSurface,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          color: colors.colorScheme.onSurface.withOpacity(0.75),
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
