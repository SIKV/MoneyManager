import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/categories/categories_page.dart';
import 'package:moneymanager/feature/home/controller/home_controller.dart';
import 'package:moneymanager/feature/home/domain/home_state.dart';
import 'package:moneymanager/feature/home/ui/glass_navigation_bar.dart';
import 'package:moneymanager/feature/statistics/statistics_page.dart';
import 'package:moneymanager/navigation/routes.dart';
import 'package:moneymanager/theme/assets.dart';
import 'package:moneymanager/ui/extensions.dart';

import '../../l10n/app_localizations.dart';
import '../../navigation/transaction_page_args.dart';
import '../../theme/spacings.dart';
import '../../theme/theme_manager.dart';
import '../more/more_page.dart';
import '../transactions/transactions_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);

    return _HomeScaffold(
      state: state,
    );
  }
}

class _HomeScaffold extends ConsumerWidget {
  static const _pages = [
    TransactionsPage(),
    CategoriesPage(),
    StatisticsPage(),
    MorePage(),
  ];

  final HomeState state;

  const _HomeScaffold({
    required this.state,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // The navigation bar floats, so the pages scroll under its glass.
      extendBody: true,
      body: _pages[state.selectedPageIndex],
      bottomNavigationBar: GlassNavigationBar(
        selectedIndex: state.selectedPageIndex,
        onDestinationSelected: (index) => _onDestinationSelected(index, ref),
        destinations: [
          GlassNavigationDestination(
            icon: Assets.homeOutline,
            selectedIcon: Assets.home,
            label: AppLocalizations.of(context)!.transactionsPage_title,
          ),
          GlassNavigationDestination(
            icon: Assets.cart,
            selectedIcon: Assets.cartFilled,
            label: AppLocalizations.of(context)!.categoriesPage_title,
          ),
          GlassNavigationDestination(
            icon: Assets.chartVertical,
            selectedIcon: Assets.chartVerticalFilled,
            label: AppLocalizations.of(context)!.statisticsPage_title,
          ),
          GlassNavigationDestination(
            icon: Assets.menuHorizontal,
            selectedIcon: Assets.menuHorizontal,
            label: AppLocalizations.of(context)!.morePage_title,
          ),
        ],
        actionIcon: const Icon(Icons.add),
        actionLabel: AppLocalizations.of(context)!.add,
        onActionPressed: () => _addTransaction(context, ref),
      ),
    );
  }

  void _onDestinationSelected(int index, WidgetRef ref) {
    ref.read(homeControllerProvider.notifier)
        .selectPage(index);
  }

  void _addTransaction(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeManagerProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      routeSettings: const RouteSettings(name: '/add-transaction-type-selector-modal'),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacings.two),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  _openAddTransaction(context, TransactionType.income);
                },
                leading: TransactionType.income.getIcon(theme.colors),
                title: Text(AppLocalizations.of(context)!.income),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  _openAddTransaction(context, TransactionType.expense);
                },
                leading: TransactionType.expense.getIcon(theme.colors),
                title: Text(AppLocalizations.of(context)!.expense),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openAddTransaction(BuildContext context, TransactionType type) {
    Navigator.pushNamed(context, AppRoutes.addTransaction,
      arguments: AddTransactionPageArgs(
        type: type,
      ),
    );
  }
}
