import 'dart:ui';

class ChartData {
  final String category;
  final num amount;
  final String formattedAmount;
  final Color color;

  ChartData({
    required this.category,
    required this.amount,
    required this.formattedAmount,
    required this.color,
  });
}
