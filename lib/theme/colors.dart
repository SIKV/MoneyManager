import 'package:flutter/material.dart';

abstract class AppColors {
  ColorScheme get colorScheme;

  Color get transactionsHeader => const Color(0xFF02B289);
  Color get statisticsHeader => const Color(0xFF02B289);
  Color get moreHeader => const Color(0xFFd5bdaf);
}

class LightAppColors extends AppColors {
  @override
  ColorScheme get colorScheme => lightColorScheme;
}

class DarkAppColors extends AppColors {
  @override
  ColorScheme get colorScheme => darkColorScheme;
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF006C53),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF81F8D0),
  onPrimaryContainer: Color(0xFF002117),
  secondary: Color(0xFF4C635A),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFCEE9DC),
  onSecondaryContainer: Color(0xFF082018),
  tertiary: Color(0xFF3F6375),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFC3E8FE),
  onTertiaryContainer: Color(0xFF001E2B),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFBFDF9),
  onBackground: Color(0xFF191C1B),
  surface: Color(0xFFFBFDF9),
  onSurface: Color(0xFF191C1B),
  surfaceVariant: Color(0xFFDBE5DF),
  onSurfaceVariant: Color(0xFF404944),
  outline: Color(0xFF707974),
  onInverseSurface: Color(0xFFEFF1EE),
  inverseSurface: Color(0xFF2E312F),
  inversePrimary: Color(0xFF64DBB4),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF006C53),
  outlineVariant: Color(0xFFBFC9C3),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF64DBB4),
  onPrimary: Color(0xFF00382A),
  primaryContainer: Color(0xFF00513E),
  onPrimaryContainer: Color(0xFF81F8D0),
  secondary: Color(0xFFB2CCC0),
  onSecondary: Color(0xFF1E352C),
  secondaryContainer: Color(0xFF344C42),
  onSecondaryContainer: Color(0xFFCEE9DC),
  tertiary: Color(0xFFA7CCE1),
  onTertiary: Color(0xFF0B3445),
  tertiaryContainer: Color(0xFF274B5D),
  onTertiaryContainer: Color(0xFFC3E8FE),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF191C1B),
  onBackground: Color(0xFFE1E3E0),
  surface: Color(0xFF191C1B),
  onSurface: Color(0xFFE1E3E0),
  surfaceVariant: Color(0xFF404944),
  onSurfaceVariant: Color(0xFFBFC9C3),
  outline: Color(0xFF89938D),
  onInverseSurface: Color(0xFF191C1B),
  inverseSurface: Color(0xFFE1E3E0),
  inversePrimary: Color(0xFF006C53),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF64DBB4),
  outlineVariant: Color(0xFF404944),
  scrim: Color(0xFF000000),
);
