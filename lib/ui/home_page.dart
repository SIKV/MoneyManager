import 'package:flutter/material.dart';

import 'more_page.dart';
import 'search_page.dart';
import 'statistics_page.dart';
import 'transactions_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.lightBlue,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Transactions'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_sharp),
              label: 'Statistics'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'More'
          ),
        ],
      ),
    );
  }
}
