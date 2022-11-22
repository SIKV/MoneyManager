import 'package:flutter/material.dart';

enum AppTheme {
  light
}

class TextStyles {
  static const TextStyle titleNormal = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle itemNormal = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle itemSectionNormal = TextStyle(
  );

  static const TextStyle subtitleNormal = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static const TextStyle income = TextStyle(
    fontSize: 18,
    color: Colors.green,
  );

  static const TextStyle outcome = TextStyle(
    fontSize: 18,
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
