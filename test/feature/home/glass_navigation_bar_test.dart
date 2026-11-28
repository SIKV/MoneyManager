import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moneymanager/feature/home/ui/glass_navigation_bar.dart';
import 'package:moneymanager/local_preferences.dart';
import 'package:moneymanager/theme/assets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_app.dart';

void main() {
  late LocalPreferences localPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    localPreferences = LocalPreferences();
    await localPreferences.load();
  });

  Future<void> pumpBar(WidgetTester tester, {
    ValueChanged<int>? onDestinationSelected,
    VoidCallback? onActionPressed,
  }) async {
    await tester.pumpWidget(
      TestApp(
        overrides: [
          localPreferencesProvider.overrideWithValue(localPreferences),
        ],
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GlassNavigationBar(
            selectedIndex: 0,
            onDestinationSelected: onDestinationSelected ?? (_) {},
            destinations: const [
              GlassNavigationDestination(icon: Assets.homeOutline, selectedIcon: Assets.home, label: 'Transactions'),
              GlassNavigationDestination(icon: Assets.cart, selectedIcon: Assets.cartFilled, label: 'Categories'),
              GlassNavigationDestination(icon: Assets.chartVertical, selectedIcon: Assets.chartVerticalFilled, label: 'Statistics'),
              GlassNavigationDestination(icon: Assets.menuHorizontal, selectedIcon: Assets.menuHorizontal, label: 'More'),
            ],
            actionIcon: const Icon(Icons.add),
            actionLabel: 'Add',
            onActionPressed: onActionPressed ?? () {},
          ),
        ),
      ),
    );
  }

  testWidgets('Tapping a destination reports its index', (tester) async {
    // GIVEN
    int? selectedIndex;
    await pumpBar(tester, onDestinationSelected: (index) => selectedIndex = index);

    // WHEN
    await tester.tap(find.bySemanticsLabel('Statistics'));

    // THEN
    expect(selectedIndex, 2);
  });

  testWidgets('Tapping the action button calls onActionPressed', (tester) async {
    // GIVEN
    var pressed = false;
    await pumpBar(tester, onActionPressed: () => pressed = true);

    // WHEN
    await tester.tap(find.bySemanticsLabel('Add'));

    // THEN
    expect(pressed, isTrue);
  });
}
