import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/feature/statistics/domain/period.dart';
import 'package:moneymanager/feature/statistics/domain/period_type.dart';

import 'chart_data.dart';
import 'chart_item.dart';

part 'statistics_chart_state.freezed.dart';

@freezed
class StatisticsChartState with _$StatisticsChartState {
  const factory StatisticsChartState({
    required ChartData incomeData,
    required ChartData expenseData,
  }) = _StatisticsChartState;
}
