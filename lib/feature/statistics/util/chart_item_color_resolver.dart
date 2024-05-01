import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/theme.dart';
import 'package:moneymanager/theme/theme_manager.dart';

final chartItemColorResolverProvider = Provider((ref) {
  final currentTheme = ref.watch(appThemeManagerProvider);
  return ChartItemColorResolver(currentTheme);
});

class ChartItemColorResolver {
  final AppTheme _theme;
  final Random _random = Random();

  ChartItemColorResolver(this._theme);

  Color getColorForIndex(int index) {
    switch (index) {
      case 0:
        return _theme.colors.chartItemColor0;
      case 1:
        return _theme.colors.chartItemColor1;
      case 2:
        return _theme.colors.chartItemColor2;
      case 3:
        return _theme.colors.chartItemColor3;
      case 4:
        return _theme.colors.chartItemColor4;
      case 5:
        return _theme.colors.chartItemColor5;
      case 6:
        return _theme.colors.chartItemColor6;
      case 7:
        return _theme.colors.chartItemColor7;
      case 8:
        return _theme.colors.chartItemColor8;
      case 9:
        return _theme.colors.chartItemColor9;
      default:
        return _generateRandom();
    }
  }

  Color _generateRandom() {
    return Color.fromARGB(
        255,
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
    );
  }
}
