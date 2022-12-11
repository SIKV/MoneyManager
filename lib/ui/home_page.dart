import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/localizations.dart';

import '../theme/icons.dart';
import '../theme/theme.dart';
import '../feature/more/more_page.dart';
import '../feature/search/search_page.dart';
import '../feature/statistics/statistics_page.dart';
import '../feature/transactions/transactions_page.dart';

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
    StatisticsPage(),
    Center(child: Text('Add')),
    SearchPage(),
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
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.lightBlue,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(AppIcons.transactionsPage),
                label: Strings.transactionsPageTitle.localized(context),
            ),
            BottomNavigationBarItem(
                icon: const Icon(AppIcons.statisticsPage),
                label: Strings.statisticsPageTitle.localized(context),
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: '',
            ),
            BottomNavigationBarItem(
                icon: const Icon(AppIcons.searchPage),
                label: Strings.searchPageTitle.localized(context),
            ),
            BottomNavigationBarItem(
                icon: const Icon(AppIcons.morePage),
                label: Strings.morePageTitle.localized(context),
            ),
          ],
        ),
      ),
    );
  }
}
