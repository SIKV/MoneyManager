import 'package:flutter/material.dart';

abstract class AppColors {
  ColorScheme get colorScheme;

  Color get alwaysWhite => const Color(0xFFFAFAFA);
  Color get alwaysBlack => const Color(0xFF0A0A0A);

  Color get slightlyGray;
  Color get itemTranslucentBackground;

  Color get transactionsAllHeaderStart;
  Color get transactionsAllHeaderEnd;
  Color get transactionsIncomeHeaderStart;
  Color get transactionsExpensesHeaderStart;
  Color get transactionsExpensesHeaderEnd;

  Color get expenseTransaction => const Color(0xFFF86666);
  Color get incomeTransaction => const Color(0xFF21AB8B);

  Color get chartItemColor0;
  Color get chartItemColor1;
  Color get chartItemColor2;
  Color get chartItemColor3;
  Color get chartItemColor4;
  Color get chartItemColor5;
  Color get chartItemColor6;
  Color get chartItemColor7;
  Color get chartItemColor8;
  Color get chartItemColor9;
}

class LightAppColors extends AppColors {
  @override
  ColorScheme get colorScheme => lightColorScheme;

  @override
  Color get slightlyGray => const Color(0xBFD7D7D7);

  @override
  Color get itemTranslucentBackground => Colors.grey.shade100;

  @override
  Color get transactionsAllHeaderStart => const Color(0xff8e94f2);
  @override
  Color get transactionsAllHeaderEnd => colorScheme.primary;
  @override
  Color get transactionsIncomeHeaderStart => const Color(0xff60d394);
  @override
  Color get transactionsExpensesHeaderStart => const Color(0xffff9b85);
  @override
  Color get transactionsExpensesHeaderEnd => const Color(0xffa4133c);

  @override
  Color get chartItemColor0 => const Color(0xffd183c9);
  @override
  Color get chartItemColor1 => const Color(0xffd7bcc8);
  @override
  Color get chartItemColor2 => const Color(0xfffaa916);
  @override
  Color get chartItemColor3 => const Color(0xff725ac1);
  @override
  Color get chartItemColor4 => const Color(0xffd69f7e);
  @override
  Color get chartItemColor5 => const Color(0xff8fbb99);
  @override
  Color get chartItemColor6 => const Color(0xff989c94);
  @override
  Color get chartItemColor7 => const Color(0xff21a0a0);
  @override
  Color get chartItemColor8 => const Color(0xfffe5d26);
  @override
  Color get chartItemColor9 => const Color(0xff9b9ece);
}

class DarkAppColors extends AppColors {
  @override
  ColorScheme get colorScheme => darkColorScheme;

  @override
  Color get slightlyGray => Colors.black26;

  @override
  Color get itemTranslucentBackground => Colors.black12;

  @override
  Color get transactionsAllHeaderStart => const Color(0xff9fa0ff);
  @override
  Color get transactionsAllHeaderEnd => colorScheme.secondaryContainer;
  @override
  Color get transactionsIncomeHeaderStart => const Color(0xff60d394);
  @override
  Color get transactionsExpensesHeaderStart => const Color(0xffff9b85);
  @override
  Color get transactionsExpensesHeaderEnd => transactionsAllHeaderEnd;

  @override
  Color get chartItemColor0 => const Color(0xffd183c9);
  @override
  Color get chartItemColor1 => const Color(0xffd7bcc8);
  @override
  Color get chartItemColor2 => const Color(0xfffaa916);
  @override
  Color get chartItemColor3 => const Color(0xff725ac1);
  @override
  Color get chartItemColor4 => const Color(0xffd69f7e);
  @override
  Color get chartItemColor5 => const Color(0xff8fbb99);
  @override
  Color get chartItemColor6 => const Color(0xff989c94);
  @override
  Color get chartItemColor7 => const Color(0xff21a0a0);
  @override
  Color get chartItemColor8 => const Color(0xfffe5d26);
  @override
  Color get chartItemColor9 => const Color(0xff9b9ece);
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff2b739a),
  surfaceTint: Color(0xff2b739a),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xffc7e7ff),
  onPrimaryContainer: Color(0xff004c6c),
  secondary: Color(0xff4f616e),
  onSecondary: Color(0xffffffff),
  secondaryContainer: Color(0xffd2e5f5),
  onSecondaryContainer: Color(0xff374955),
  tertiary: Color(0xff62597c),
  onTertiary: Color(0xffffffff),
  tertiaryContainer: Color(0xffe8ddff),
  onTertiaryContainer: Color(0xff4a4263),
  error: Color(0xffba1a1a),
  onError: Color(0xffffffff),
  errorContainer: Color(0xffffdad6),
  onErrorContainer: Color(0xff93000a),
  surface: Color(0xfff6fafe),
  onSurface: Color(0xff181c20),
  onSurfaceVariant: Color(0xff41484d),
  outline: Color(0xff71787e),
  outlineVariant: Color(0xffc1c7ce),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xff2d3135),
  inversePrimary: Color(0xff92cef6),
  primaryFixed: Color(0xffc7e7ff),
  onPrimaryFixed: Color(0xff001e2e),
  primaryFixedDim: Color(0xff92cef6),
  onPrimaryFixedVariant: Color(0xff004c6c),
  secondaryFixed: Color(0xffd2e5f5),
  onSecondaryFixed: Color(0xff0b1d29),
  secondaryFixedDim: Color(0xffb6c9d8),
  onSecondaryFixedVariant: Color(0xff374955),
  tertiaryFixed: Color(0xffe8ddff),
  onTertiaryFixed: Color(0xff1e1635),
  tertiaryFixedDim: Color(0xffccc0e9),
  onTertiaryFixedVariant: Color(0xff4a4263),
  surfaceDim: Color(0xffd7dadf),
  surfaceBright: Color(0xfff6fafe),
  surfaceContainerLowest: Color(0xffffffff),
  surfaceContainerLow: Color(0xfff1f4f9),
  surfaceContainer: Color(0xffebeef3),
  surfaceContainerHigh: Color(0xffe5e8ed),
  surfaceContainerHighest: Color(0xffdfe3e7),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xff92cef6),
  surfaceTint: Color(0xff92cef6),
  onPrimary: Color(0xff00344c),
  primaryContainer: Color(0xff004c6c),
  onPrimaryContainer: Color(0xffc7e7ff),
  secondary: Color(0xffb6c9d8),
  onSecondary: Color(0xff21323e),
  secondaryContainer: Color(0xff374955),
  onSecondaryContainer: Color(0xffd2e5f5),
  tertiary: Color(0xffccc0e9),
  onTertiary: Color(0xff342b4b),
  tertiaryContainer: Color(0xff4a4263),
  onTertiaryContainer: Color(0xffe8ddff),
  error: Color(0xffffb4ab),
  onError: Color(0xff690005),
  errorContainer: Color(0xff93000a),
  onErrorContainer: Color(0xffffdad6),
  surface: Color(0xff101417),
  onSurface: Color(0xffdfe3e7),
  onSurfaceVariant: Color(0xffc1c7ce),
  outline: Color(0xff8b9198),
  outlineVariant: Color(0xff41484d),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xffdfe3e7),
  inversePrimary: Color(0xff226487),
  primaryFixed: Color(0xffc7e7ff),
  onPrimaryFixed: Color(0xff001e2e),
  primaryFixedDim: Color(0xff92cef6),
  onPrimaryFixedVariant: Color(0xff004c6c),
  secondaryFixed: Color(0xffd2e5f5),
  onSecondaryFixed: Color(0xff0b1d29),
  secondaryFixedDim: Color(0xffb6c9d8),
  onSecondaryFixedVariant: Color(0xff374955),
  tertiaryFixed: Color(0xffe8ddff),
  onTertiaryFixed: Color(0xff1e1635),
  tertiaryFixedDim: Color(0xffccc0e9),
  onTertiaryFixedVariant: Color(0xff4a4263),
  surfaceDim: Color(0xff101417),
  surfaceBright: Color(0xff353a3d),
  surfaceContainerLowest: Color(0xff0a0f12),
  surfaceContainerLow: Color(0xff181c20),
  surfaceContainer: Color(0xff1c2024),
  surfaceContainerHigh: Color(0xff262a2e),
  surfaceContainerHighest: Color(0xff313539),
);
