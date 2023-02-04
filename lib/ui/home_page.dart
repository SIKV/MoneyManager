import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/localizations.dart';
import 'package:moneymanager/theme/theme.dart';

import '../feature/more/more_page.dart';
import '../feature/transactions/transactions_page.dart';
import '../theme/icons.dart';
import '../theme/spacings.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends ConsumerState<ConsumerStatefulWidget> {
  int _selectedPageIndex = 0;

  static final _pages = [
    const TransactionsPage(),
    Container(), // TODO:
    const MorePage(),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _addTransaction(WidgetRef ref) {
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
                  // TODO: Implement.
                },
                leading: Icon(AppIcons.addIncome,
                  color: theme.colors.incomeTransaction,
                ),
                title: Text(Strings.income.localized(context)),
              ),
              ListTile(
                onTap: () {
                  // TODO: Implement.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedPageIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(AppIcons.transactionsPage),
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
                onPressed: () => _addTransaction(ref),
                color: Colors.white,
                icon: const Icon(Icons.add),
              ),
            ),
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.morePage),
            label: Strings.morePageTitle.localized(context),
          ),
        ],
      ),
    );
  }
}
