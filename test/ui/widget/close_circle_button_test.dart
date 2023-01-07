import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneymanager/ui/widget/close_circle_button.dart';

import '../../mock_navigator_observer.dart';
import '../../mock_route.dart';
import '../../test_app.dart';

void main() {
  testWidgets('CloseCircleButton onTap triggers Navigator.pop', (tester) async {
    final mockNavigatorObserver = MockNavigatorObserver();
    registerFallbackValue(mockRoute);

    await tester.pumpWidget(
      TestApp(
        navigatorObservers: [mockNavigatorObserver],
        child: const CloseCircleButton(),
      ),
    );

    expect(find.byType(CloseCircleButton), findsOneWidget);

    await tester.tap(find.byType(CloseCircleButton));
    await tester.pumpAndSettle();

    verify(() => mockNavigatorObserver.didPop(any(), any())).called(1);
  });
}
