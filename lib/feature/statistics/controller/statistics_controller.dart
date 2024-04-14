import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/statistics/domain/statistics_state.dart';
import 'package:moneymanager/feature/statistics/period_manager.dart';

import '../../../ext/auto_dispose_async_notifier_ext.dart';
import '../domain/period_type.dart';

final statisticsControllerProvider = AsyncNotifierProvider
    .autoDispose<StatisticsController, StatisticsState>(() {
      return StatisticsController();
});

class StatisticsController extends AutoDisposeAsyncNotifierExt<StatisticsState> {

  late final PeriodManager _periodManager;

  @override
  FutureOr<StatisticsState> build() {
    _periodManager = PeriodManager(PeriodType.monthly);

    return StatisticsState(
      periodTypes: PeriodType.values,
      selectedPeriodType: _periodManager.type,
      selectedPeriod: _periodManager.period,
      incomeData: [],
      expenseData: [],
    );
  }

  void setPeriodType(PeriodType type) async {
    _periodManager.type = type;

    updateState((state) => state.copyWith(
      selectedPeriodType: _periodManager.type,
      selectedPeriod: _periodManager.period,
    ));
  }

  void goToPreviousPeriod() {
    updateState((state) => state.copyWith(
      selectedPeriod: _periodManager.goToPrevious(),
    ));
  }

  void goToNextPeriod() {
    updateState((state) => state.copyWith(
      selectedPeriod: _periodManager.goToNext(),
    ));
  }
}
