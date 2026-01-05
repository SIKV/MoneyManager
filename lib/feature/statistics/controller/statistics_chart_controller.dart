import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/common/currency_formatter.dart';
import 'package:moneymanager/data/providers.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/statistics/controller/statistics_controller.dart';
import 'package:moneymanager/feature/statistics/domain/period.dart';
import 'package:moneymanager/feature/statistics/util/chart_item_mapper.dart';
import 'package:moneymanager/feature/statistics/util/extensions.dart';

import '../../../ext/auto_dispose_async_notifier_ext.dart';
import '../domain/chart_data.dart';
import '../domain/statistics_chart_state.dart';
import '../util/chart_item_color_resolver.dart';

final statisticsChartControllerProvider = AsyncNotifierProvider
    .autoDispose<StatisticsChartController, StatisticsChartState>(() {
      return StatisticsChartController();
});

class StatisticsChartController extends AutoDisposeAsyncNotifierExt<StatisticsChartState> {

  @override
  FutureOr<StatisticsChartState> build() async {
    final state = ref.watch(statisticsControllerProvider);

    return StatisticsChartState(
      incomeData: await _getData(TransactionType.income, state.selectedPeriod),
      expenseData: await _getData(TransactionType.expense, state.selectedPeriod),
    );
  }

  Future<ChartData> _getData(TransactionType transactionType, Period period) async {
    final repo = await ref.watch(transactionsRepositoryProvider);

    final transactions = await repo.getAll(
      typeFilter: transactionType.toTypeFilter(),
      fromTimestamp: period.startTimestamp,
      toTimestamp: period.endTimestamp,
    ).first;

    final double totalAmount = transactions.fold(0, (prev, e) => prev + e.amount);
    final String currencyCode = transactions.firstOrNull?.currency.code ?? '';
    final currencyFormatter = ref.watch(currencyFormatterProvider);

    ChartItemColorResolver colorResolver = ref.watch(chartItemColorResolverProvider);

    final chartItems = transactions.toChartItem(currencyFormatter, colorResolver);
    // Sort by amount (descending).
    chartItems.sort((a, b) => b.amount.compareTo(a.amount));

    return ChartData(
      transactionType: transactionType,
      totalAmount: '${currencyFormatter.format(totalAmount)} $currencyCode',
      transactionsCount: transactions.length,
      items: chartItems
    );
  }
}
