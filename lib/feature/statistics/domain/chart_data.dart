import 'package:moneymanager/domain/transaction_type.dart';

import 'chart_item.dart';

class ChartData {
  final TransactionType transactionType;
  final String totalAmount;
  final int transactionsCount;
  final List<ChartItem> items;

  ChartData({
    required this.transactionType,
    required this.totalAmount,
    required this.transactionsCount,
    required this.items,
  });
}
