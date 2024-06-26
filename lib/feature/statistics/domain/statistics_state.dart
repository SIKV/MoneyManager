import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/feature/statistics/domain/period.dart';
import 'package:moneymanager/feature/statistics/domain/period_type.dart';

import 'chart_data.dart';
import 'chart_item.dart';

part 'statistics_state.freezed.dart';

@freezed
class StatisticsState with _$StatisticsState {
  const factory StatisticsState({
    required List<PeriodType> periodTypes,
    required PeriodType selectedPeriodType,
    required Period selectedPeriod,
  }) = _StatisticsState;
}
