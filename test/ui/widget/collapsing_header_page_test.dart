import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moneymanager/local_preferences.dart';
import 'package:moneymanager/theme/colors.dart';
import 'package:moneymanager/ui/widget/collapsing_header_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_app.dart';

const _expandedHeight = 300.0;
const _collapsedHeight = 80.0;

void main() {
  late LocalPreferences localPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    localPreferences = LocalPreferences();
    await localPreferences.load();
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      TestApp(
        overrides: [
          localPreferencesProvider.overrideWithValue(localPreferences),
        ],
        child: CollapsingHeaderPage(
          colors: LightAppColors(),
          startColor: const Color(0xFF00FF00),
          endColor: const Color(0xFF0000FF),
          collapsedHeight: _collapsedHeight,
          expandedHeight: _expandedHeight,
          title: '100',
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => SizedBox(height: 100, child: Text('$index')),
              childCount: 20,
            ),
          ),
        ),
      ),
    );
  }

  double headerHeight(WidgetTester tester) {
    final header = tester.renderObject<RenderSliverPersistentHeader>(
      find.byType(SliverPersistentHeader),
    );
    return header.child!.size.height;
  }

  double titleTop(WidgetTester tester) {
    return tester.getTopLeft(find.text('100', findRichText: true)).dy;
  }

  testWidgets('Header stretches with the over-scroll', (tester) async {
    await pumpPage(tester);

    expect(headerHeight(tester), _expandedHeight);

    final titleTopAtRest = titleTop(tester);

    final gesture = await tester.startGesture(const Offset(200, 400));
    await gesture.moveBy(const Offset(0, 120));
    await tester.pump();

    final overscroll = -tester.state<ScrollableState>(
      find.byType(Scrollable),
    ).position.pixels;

    expect(overscroll, greaterThan(0));
    expect(headerHeight(tester), _expandedHeight + overscroll);
    // The title follows the over-scroll instead of staying pinned to the top.
    expect(titleTop(tester), titleTopAtRest + overscroll);

    await gesture.up();
    await tester.pumpAndSettle();

    expect(headerHeight(tester), _expandedHeight);
    expect(titleTop(tester), titleTopAtRest);
  });

  testWidgets('Header collapses when scrolling down', (tester) async {
    await pumpPage(tester);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(headerHeight(tester), _collapsedHeight);
  });
}
