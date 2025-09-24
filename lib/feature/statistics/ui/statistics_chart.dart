import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/feature/statistics/controller/statistics_chart_controller.dart';
import 'package:moneymanager/feature/statistics/domain/chart_data.dart';
import 'package:moneymanager/theme/spacings.dart';
import 'package:moneymanager/ui/widget/something_went_wrong.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../domain/transaction_type.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/widget/no_items.dart';
import '../domain/chart_item.dart';

class StatisticsChart extends ConsumerWidget {
  final TransactionType transactionType;

  const StatisticsChart(this.transactionType, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(statisticsChartControllerProvider);

    return state.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (_, __) => const SomethingWentWrong(),
      data: (state) {
        ChartData data;

        switch (transactionType) {
          case TransactionType.income:
            data = state.incomeData;
            break;
          case TransactionType.expense:
            data = state.expenseData;
            break;
        }

        if (data.items.isEmpty) {
          return Center(
            child: NoItems(
              title: AppLocalizations.of(context)!.noData,
            ),
          );
        }

        return SfCircularChart(
          title: ChartTitle(
            text: _createTitle(context, data),
            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
            ),
          ),
          legend: Legend(
            isVisible: true,
            padding: 0,
            height: '65%',
            itemPadding: 0,
            position: LegendPosition.bottom,
            overflowMode: LegendItemOverflowMode.wrap,
            legendItemBuilder: (legendText, series, point, seriesIndex) {
              return _LegendItem(data: data.items[seriesIndex]);
            },
          ),
          series: <PieSeries<ChartItem, String>>[
            PieSeries<ChartItem, String>(
              dataSource: data.items,
              xValueMapper: (data, _) => data.category,
              yValueMapper: (data, _) => data.amount,
              dataLabelMapper: (data, _) => data.category,
              pointColorMapper: (data, _) => data.color,
            ),
          ],
        );
      },
    );
  }

  String _createTitle(BuildContext context, ChartData data) {
    String total = '';

    switch (data.transactionType) {
      case TransactionType.income:
        total = AppLocalizations.of(context)!.statisticsPage_totalIncome;
        break;
      case TransactionType.expense:
        total = AppLocalizations.of(context)!.statisticsPage_totalExpenses;
        break;
    }

    return '$total ${data.totalAmount}\n${AppLocalizations.of(context)!.statisticsPage_transactionsCount} ${data.transactionsCount}';
  }
}

class _LegendItem extends StatelessWidget {
  final ChartItem data;

  const _LegendItem({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final String transactionsCount = Intl.plural(data.transactionCount,
      zero: '${data.transactionCount} ${AppLocalizations.of(context)!.lTransactions}',
      one: '${data.transactionCount} ${AppLocalizations.of(context)!.lTransaction}',
      other: '${data.transactionCount} ${AppLocalizations.of(context)!.lTransactions}',
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacings.three,
        vertical: Spacings.two,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: data.color,
            ),
          ),
          const SizedBox(width: Spacings.three),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.category),
              Text(transactionsCount,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const Spacer(),
          Text(data.formattedAmount),
        ],
      ),
    );
  }
}
