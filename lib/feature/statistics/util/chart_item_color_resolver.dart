import 'package:flutter/material.dart';

class ChartItemColorResolver {

  // TODO: Implement.
  Color getColorForIndex(int index) {
    if (index == 0) {
      return Colors.orange;
    } else if (index == 1) {
      return Colors.blue;
    } else if (index == 2) {
      return Colors.green;
    }
    return Colors.white;
  }
}
