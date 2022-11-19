import 'package:flutter/material.dart';

enum AppTheme {
  light
}

class TextStyles {
  static const TextStyle title1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle subtitle1 = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );
}

ThemeData createTheme(AppTheme theme) {
  return ThemeData(
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
    ),
  );
}
