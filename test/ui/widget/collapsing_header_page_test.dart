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

// The size and the padding the expanded title is laid out with.
const _titleFontSize = 46.0;
const _titlePadding = 36.0;

const _longTitle = '1,234,567,890,123,456,789.00';

void main() {
  late LocalPreferences localPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    localPreferences = LocalPreferences();
    await localPreferences.load();
  });

  Future<void> pumpPage(WidgetTester tester, {String title = '100'}) async {
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
          title: title,
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

  double titleFontSize(WidgetTester tester, String title) {
    final richText = tester.widget<RichText>(
      find.text(title, findRichText: true),
    );
    final span = (richText.text as TextSpan).children!.first as TextSpan;
    return span.style!.fontSize!;
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

  testWidgets('Title that fits keeps its size', (tester) async {
    await pumpPage(tester);

    expect(titleFontSize(tester, '100'), _titleFontSize);
  });

  testWidgets('Title too wide for the header is scaled down', (tester) async {
    await pumpPage(tester, title: _longTitle);

    expect(titleFontSize(tester, _longTitle), lessThan(_titleFontSize));

    final pageWidth = tester.getSize(find.byType(CollapsingHeaderPage)).width;
    final titleRight = tester.getBottomRight(
      find.text(_longTitle, findRichText: true),
    ).dx;

    expect(titleRight, lessThanOrEqualTo(pageWidth - _titlePadding));
  });

  testWidgets('Scaled down title grows back when the header collapses',
      (tester) async {
    await pumpPage(tester, title: _longTitle);

    final expandedFontSize = titleFontSize(tester, _longTitle);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();

    // The collapsed title starts off smaller, so it needs less scaling down.
    expect(titleFontSize(tester, _longTitle), greaterThan(expandedFontSize));
  });
}
