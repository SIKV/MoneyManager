import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/spacings.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../ui/widget/no_items.dart';
import '../domain/chart_data.dart';

class StatisticsChart extends ConsumerWidget {
  final List<ChartData> data;

  const StatisticsChart(this.data, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.isEmpty) {
      return Center(
        child: NoItems(
          title: AppLocalizations.of(context)!.noData,
        ),
      );
    }
    return SfCircularChart(
      legend: Legend(
        isVisible: true,
        padding: 0,
        height: '65%',
        itemPadding: 0,
        position: LegendPosition.bottom,
        overflowMode: LegendItemOverflowMode.wrap,
        legendItemBuilder: (legendText, series, point, seriesIndex) {
          return _LegendItem(data: data[seriesIndex]);
        },
      ),
      series: <PieSeries<ChartData, String>>[
        PieSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (data, _) => data.category,
          yValueMapper: (data, _) => data.amount,
          dataLabelMapper: (data, _) => data.category,
          pointColorMapper: (data, _) => data.color,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final ChartData data;

  const _LegendItem({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
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
          Text(data.category),
          const Spacer(),
          Text(data.formattedAmount),
        ],
      ),
    );
  }
}
