import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/localizations.dart';

import '../theme/theme.dart';
import 'more_page.dart';
import 'search_page.dart';
import 'statistics_page.dart';
import 'transactions_page.dart';

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
                icon: const Icon(Icons.home),
                label: Strings.transactionsPageTitle.localized(context),
            ),
            BottomNavigationBarItem(
                icon: const Icon(Icons.bar_chart_sharp),
                label: Strings.statisticsPageTitle.localized(context),
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: '',
            ),
            BottomNavigationBarItem(
                icon: const Icon(Icons.search),
                label: Strings.searchPageTitle.localized(context),
            ),
            BottomNavigationBarItem(
                icon: const Icon(Icons.more_horiz),
                label: Strings.morePageTitle.localized(context),
            ),
          ],
        ),
      ),
    );
  }
}
