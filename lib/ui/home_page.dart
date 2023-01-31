import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/localizations.dart';
import 'package:moneymanager/routes.dart';

import '../feature/more/more_page.dart';
import '../feature/transactions/transactions_page.dart';
import '../theme/icons.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomePageState();
  }
}

// TODO: Refactor
class _HomePageState extends ConsumerState<ConsumerStatefulWidget> {
  int _selectedIndex = 0;

  static final _pages = [
    const TransactionsPage(),
    Container(),
    const MorePage(),
  ];

  void _onDestinationSelected(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, AppRoutes.addTransaction);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(AppIcons.transactionsPage),
            label: Strings.transactionsPageTitle.localized(context),
          ),
          const NavigationDestination(
            icon: Icon(Icons.add),
            label: '',
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
