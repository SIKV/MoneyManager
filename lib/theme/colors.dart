import 'package:flutter/material.dart';

abstract class AppColors {
  ColorScheme get colorScheme;

  Color get alwaysWhite => const Color(0xFFFAFAFA);
  Color get alwaysBlack => const Color(0xFF0A0A0A);

  Color get itemTranslucentBackground;

  Color get transactionsHeaderStart;
  Color get transactionsHeaderEnd;

  Color get moreHeaderStart;
  Color get moreHeaderEnd;

  Color get statisticsHeaderStart => const Color(0xFF3074FF);
  Color get statisticsHeaderEnd => const Color(0xFFD244E7);

  Color get expenseTransaction => const Color(0xFFFA5959);
  Color get incomeTransaction => const Color(0xFF21AB8B);
}

class LightAppColors extends AppColors {
  @override
  ColorScheme get colorScheme => lightColorScheme;

  @override
  Color get itemTranslucentBackground => const Color(0xBFFFFFFF);

  @override
  Color get transactionsHeaderStart => colorScheme.primary;

  @override
  Color get transactionsHeaderEnd => colorScheme.tertiary;

  @override
  Color get moreHeaderStart => colorScheme.secondary;

  @override
  Color get moreHeaderEnd => colorScheme.tertiary;
}

class DarkAppColors extends AppColors {
  @override
  ColorScheme get colorScheme => darkColorScheme;

  @override
  Color get itemTranslucentBackground => Colors.black12;

  @override
  Color get transactionsHeaderStart => colorScheme.primary;

  @override
  Color get transactionsHeaderEnd => colorScheme.tertiaryContainer;

  @override
  Color get moreHeaderStart => colorScheme.secondaryContainer;

  @override
  Color get moreHeaderEnd => colorScheme.tertiaryContainer;
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF006688),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFC1E8FF),
  onPrimaryContainer: Color(0xFF001E2B),
  secondary: Color(0xFF4E616C),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFD1E6F3),
  onSecondaryContainer: Color(0xFF091E28),
  tertiary: Color(0xFF5F5A7D),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFE5DEFF),
  onTertiaryContainer: Color(0xFF1B1736),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFBFCFE),
  onBackground: Color(0xFF191C1E),
  surface: Color(0xFFFBFCFE),
  onSurface: Color(0xFF191C1E),
  surfaceVariant: Color(0xFFDCE3E9),
  onSurfaceVariant: Color(0xFF40484D),
  outline: Color(0xFF71787D),
  onInverseSurface: Color(0xFFF0F1F3),
  inverseSurface: Color(0xFF2E3133),
  inversePrimary: Color(0xFF74D1FF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF006688),
  outlineVariant: Color(0xFFC0C7CD),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF3DBAFA),
  onPrimary: Color(0xFF003548),
  primaryContainer: Color(0xFF004D67),
  onPrimaryContainer: Color(0xFFC1E8FF),
  secondary: Color(0xFFB5C9D7),
  onSecondary: Color(0xFF1F333D),
  secondaryContainer: Color(0xFF364954),
  onSecondaryContainer: Color(0xFFD1E6F3),
  tertiary: Color(0xFFC9C2EA),
  onTertiary: Color(0xFF312C4C),
  tertiaryContainer: Color(0xFF474364),
  onTertiaryContainer: Color(0xFFE5DEFF),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF191C1E),
  onBackground: Color(0xFFE1E2E5),
  surface: Color(0xFF191C1E),
  onSurface: Color(0xFFE1E2E5),
  surfaceVariant: Color(0xFF40484D),
  onSurfaceVariant: Color(0xFFC0C7CD),
  outline: Color(0xFF8A9297),
  onInverseSurface: Color(0xFF191C1E),
  inverseSurface: Color(0xFFE1E2E5),
  inversePrimary: Color(0xFF006688),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF74D1FF),
  outlineVariant: Color(0xFF40484D),
  scrim: Color(0xFF000000),
);
