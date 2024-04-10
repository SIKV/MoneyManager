import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/statistics/domain/period.dart';
import 'package:moneymanager/feature/statistics/domain/statistics_state.dart';

import '../../../ext/auto_dispose_async_notifier_ext.dart';
import '../domain/period_type.dart';

final statisticsControllerProvider = AsyncNotifierProvider
    .autoDispose<StatisticsController, StatisticsState>(() {
      return StatisticsController();
});

class StatisticsController extends AutoDisposeAsyncNotifierExt<StatisticsState> {

  @override
  FutureOr<StatisticsState> build() {
    return StatisticsState(
      periodTypes: PeriodType.values,
      selectedPeriodType: PeriodType.monthly,
      selectedPeriod: Period(
        startTimestamp: 0,
        endTimestamp: 0,
        formatted: 'April 2024' // TODO: Mocked value.
      ),
      incomeData: [],
      expenseData: [],
    );
  }

  void setPeriodType(PeriodType type) async {
    updateState((state) => state.copyWith(
      selectedPeriodType: type,
    ));
  }

  void goToPreviousPeriod() {
    // TODO: Implement.
  }

  void goToNextPeriod() {
    // TODO: Implement.
  }
}
