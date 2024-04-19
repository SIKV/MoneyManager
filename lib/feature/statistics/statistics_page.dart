import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/statistics/domain/period_type.dart';
import 'package:moneymanager/feature/statistics/ui/period_selector.dart';
import 'package:moneymanager/feature/statistics/ui/period_type_selector.dart';
import 'package:moneymanager/feature/statistics/ui/statistics_chart.dart';
import 'package:moneymanager/ui/extensions.dart';

import 'controller/statistics_controller.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(statisticsControllerProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(AppLocalizations.of(context)!.statistics),
              actions: [
                PeriodTypeSelector(
                  types: state.periodTypes,
                  selectedType: state.selectedPeriodType,
                  onSelectedTypeChanged: (type) =>
                      _onSelectedPeriodTypeChanged(ref, type),
                ),
              ],
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(96), // TODO: Use constant.
                  child: Column(
                    children: [
                      PeriodSelector(
                        formattedPeriod: state.selectedPeriod.formatted,
                        onGoToPrevious: () => _onGoToPreviousPeriod(ref),
                        onGoToNext: () => _onGoToNextPeriod(ref),
                      ),
                      TabBar(
                        tabs: [
                          Tab(text: TransactionType.income.getTitle(
                              context)),
                          Tab(text: TransactionType.expense.getTitle(
                              context, usePlural: true)),
                        ],
                      ),
                    ],
                  )
              ),
            ),
            const SliverFillRemaining(
              child: TabBarView(
                children: [
                  StatisticsChart(TransactionType.income),
                  StatisticsChart(TransactionType.expense),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSelectedPeriodTypeChanged(WidgetRef ref, PeriodType type) {
    ref.read(statisticsControllerProvider.notifier)
        .setPeriodType(type);
  }

  void _onGoToPreviousPeriod(WidgetRef ref) {
    ref.read(statisticsControllerProvider.notifier)
        .goToPreviousPeriod();
  }

  void _onGoToNextPeriod(WidgetRef ref) {
    ref.read(statisticsControllerProvider.notifier)
        .goToNextPeriod();
  }
}
