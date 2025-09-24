import 'package:collection/collection.dart';
import 'package:moneymanager/domain/transaction.dart';

import '../../../common/currency_formatter.dart';
import '../domain/chart_item.dart';
import 'chart_item_color_resolver.dart';

extension ChartItemMapping on List<Transaction> {

  List<ChartItem> toChartItem(
      CurrencyFormatter currencyFormatter,
      ChartItemColorResolver colorResolver,
  ) {
    final grouped = groupListsBy((e) => e.category);
    List<ChartItem> result = [];

    final String currencyCode = firstOrNull?.currency.code ?? '';

    grouped.forEach((category, list) {
      double amount = list.fold(0, (prev, e) => prev + e.amount);

      final chartData = ChartItem(
        category: category.title,
        amount: amount,
        formattedAmount: '${currencyFormatter.format(amount)} $currencyCode',
        transactionCount: list.length,
        color: colorResolver.getColorForIndex(result.length),
      );

      result.add(chartData);
    });

    return result;
  }
}
