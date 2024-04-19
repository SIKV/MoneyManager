import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/ext/auto_dispose_notifier_ext.dart';
import 'package:moneymanager/feature/statistics/domain/statistics_state.dart';

import '../domain/period_type.dart';
import '../util/period_manager.dart';

final statisticsControllerProvider = NotifierProvider
    .autoDispose<StatisticsController, StatisticsState>(() {
      return StatisticsController();
});

class StatisticsController extends AutoDisposeNotifierExt<StatisticsState> {

  final PeriodManager _periodManager = PeriodManager(PeriodType.monthly);

  @override
  StatisticsState build() {
    return StatisticsState(
      periodTypes: PeriodType.values,
      selectedPeriodType: _periodManager.type,
      selectedPeriod: _periodManager.period,
    );
  }

  void setPeriodType(PeriodType type) {
    _periodManager.type = type;

    updateState((state) => state.copyWith(
      selectedPeriodType: _periodManager.type,
      selectedPeriod: _periodManager.period,
    ));
  }

  void goToPreviousPeriod() {
    _periodManager.goToPrevious();

    updateState((state) => state.copyWith(
      selectedPeriod: _periodManager.period,
    ));
  }

  void goToNextPeriod() {
    _periodManager.goToNext();

    updateState((state) => state.copyWith(
      selectedPeriod: _periodManager.period,
    ));
  }
}
