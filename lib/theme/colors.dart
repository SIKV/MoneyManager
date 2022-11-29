import 'package:flutter/material.dart';

abstract class AppColors {
  Color get primary => Colors.blueAccent;
  Color get canvas;
  Color get bottomSheetBackgroundColor;
}

class AppColorsLight extends AppColors {

  @override
  Color get canvas => const Color.fromARGB(255, 245, 245, 245);

  @override
  Color get bottomSheetBackgroundColor => const Color.fromARGB(255, 245, 245, 245);
}

class AppColorsDark extends AppColors {

  @override
  Color get canvas => const Color.fromARGB(255, 25, 25, 25);

  @override
  Color get bottomSheetBackgroundColor => const Color.fromARGB(255, 50, 50, 50);
}
