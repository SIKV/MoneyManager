import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moneymanager/ui/widget/pull_to_activate.dart';

import '../../test_app.dart';

const _threshold = 100.0;
const _indicatorKey = Key('indicator');

void main() {
  int activations = 0;
  double lastProgress = 0;
  bool lastArmed = false;

  setUp(() {
    activations = 0;
    lastProgress = 0;
    lastArmed = false;
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      TestApp(
        child: PullToActivate(
          threshold: _threshold,
          onActivate: () => activations++,
          indicatorBuilder: (context, progress, armed) {
            lastProgress = progress;
            lastArmed = armed;
            return const SizedBox(key: _indicatorKey, height: 44, width: 44);
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => SizedBox(height: 100, child: Text('$index')),
                  childCount: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  testWidgets('Activates when released past the threshold', (tester) async {
    await pumpPage(tester);

    final gesture = await tester.startGesture(const Offset(200, 300));
    await gesture.moveBy(const Offset(0, _threshold + 40));
    await tester.pump();

    expect(lastArmed, true);
    expect(lastProgress, 1.0);
    expect(activations, 0);

    await gesture.up();
    await tester.pumpAndSettle();

    expect(activations, 1);
    expect(lastArmed, false);
    expect(lastProgress, 0.0);
  });

  testWidgets('Does not activate when released below the threshold', (tester) async {
    await pumpPage(tester);

    final gesture = await tester.startGesture(const Offset(200, 300));
    await gesture.moveBy(const Offset(0, _threshold / 2));
    await tester.pump();

    expect(lastArmed, false);
    expect(lastProgress, greaterThan(0));

    await gesture.up();
    await tester.pumpAndSettle();

    expect(activations, 0);
  });

  testWidgets('Does not activate when the pull is cancelled before the release', (tester) async {
    await pumpPage(tester);

    final gesture = await tester.startGesture(const Offset(200, 300));
    await gesture.moveBy(const Offset(0, _threshold + 40));
    await tester.pump();

    expect(lastArmed, true);

    await gesture.moveBy(const Offset(0, -_threshold));
    await tester.pump();

    expect(lastArmed, false);

    await gesture.up();
    await tester.pumpAndSettle();

    expect(activations, 0);
  });

  testWidgets('Indicator is placed at the top center, above the child', (tester) async {
    await pumpPage(tester);

    final indicator = tester.getRect(find.byKey(_indicatorKey));
    final page = tester.getRect(find.byType(CustomScrollView));

    expect(indicator.center.dx, page.center.dx);
    expect(indicator.top, page.top);
  });

  testWidgets('Does not activate when scrolling down', (tester) async {
    await pumpPage(tester);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(activations, 0);
    expect(lastProgress, 0.0);
  });
}
