import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/home/controller/home_controller.dart';
import 'package:moneymanager/feature/home/domain/home_state.dart';
import 'package:moneymanager/localizations.dart';
import 'package:moneymanager/navigation/routes.dart';
import 'package:moneymanager/theme/assets.dart';
import 'package:moneymanager/ui/widget/SvgIcon.dart';

import '../../navigation/transaction_page_args.dart';
import '../../theme/icons.dart';
import '../../theme/spacings.dart';
import '../../theme/theme_manager.dart';
import '../more/more_page.dart';
import '../transactions/transactions_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);

    ref.listen(homeControllerProvider, (previous, next) {
      if (next.value?.shouldAddAccount == true) {
        Navigator.pushNamed(context, AppRoutes.addAccount);
      }
    });

    return state.when(
      loading: () => Container(), // TODO: Implement.
      error: (_, __) => Container(), // TODO: Implement.
      data: (state) => _HomeScaffold(
        state: state,
      ),
    );
  }
}

class _HomeScaffold extends ConsumerWidget {
  static final _pages = [
    const TransactionsPage(),
    Container(), // TODO
    const MorePage(),
  ];

  final HomeState state;

  const _HomeScaffold({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: _pages[state.selectedPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: state.selectedPageIndex,
        onDestinationSelected: (index) => _onDestinationSelected(index, ref),
        destinations: [
          NavigationDestination(
            icon: const SvgIcon(Assets.homeOutline),
            selectedIcon: const SvgIcon(Assets.home),
            label: Strings.transactionsPageTitle.localized(context),
          ),
          Center(
            child: Ink(
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ],
                ),
                shape: const CircleBorder(),
              ),
              child: IconButton(
                onPressed: () => _addTransaction(context, ref),
                color: Colors.white,
                icon: const Icon(Icons.add),
              ),
            ),
          ),
          NavigationDestination(
            icon: const SvgIcon(Assets.menuHorizontal),
            label: Strings.morePageTitle.localized(context),
          ),
        ],
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
                  _openTransactionPage(context, TransactionType.income);
                },
                leading: Icon(AppIcons.addIncome,
                  color: theme.colors.incomeTransaction,
                ),
                title: Text(Strings.income.localized(context)),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  _openTransactionPage(context, TransactionType.expense);
                },
                leading: Icon(AppIcons.addExpense,
                  color: theme.colors.expenseTransaction,
                ),
                title: Text(Strings.expense.localized(context)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openTransactionPage(BuildContext context, TransactionType type) {
    Navigator.pushNamed(context, AppRoutes.transaction,
      arguments: TransactionPageArgs(
        type: type,
      ),
    );
  }
}
