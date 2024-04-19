import 'dart:ui';

class ChartItem {
  final String category;
  final num amount;
  final String formattedAmount;
  final Color color;

  ChartItem({
    required this.category,
    required this.amount,
    required this.formattedAmount,
    required this.color,
  });
}
