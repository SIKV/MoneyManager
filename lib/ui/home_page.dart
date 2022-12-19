import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/localizations.dart';

import '../feature/more/more_page.dart';
import '../feature/transactions/transactions_page.dart';
import '../theme/icons.dart';
import '../theme/theme.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends ConsumerState<ConsumerStatefulWidget> {
  int _selectedIndex = 0;

  static const _pages = [
    TransactionsPage(),
    Center(child: Text('Add')),
    MorePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return Theme(
      data: appTheme.themeData(),
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
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
      ),
    );
  }
}
