import 'package:moneymanager/feature/statistics/domain/period.dart';
import 'package:moneymanager/feature/statistics/domain/period_type.dart';
import 'package:moneymanager/feature/statistics/util/period_manager.dart';
import 'package:test/test.dart';

// Written by ChatGPT 3.5.

void main() {
  group('PeriodManager Tests', () {
    test('Initialization Test', () {
      // Create an instance of PeriodManager with a type
      PeriodManager manager = PeriodManager(PeriodType.monthly);

      // Check the initial type
      expect(manager.type, PeriodType.monthly);

      // Check the initial period is not null
      expect(manager.period, isNotNull);
    });

    test('Set Type Test', () {
      PeriodManager manager = PeriodManager(PeriodType.monthly);

      // Change type and verify
      manager.type = PeriodType.annually;
      expect(manager.type, PeriodType.annually);
      expect(manager.period, isNotNull);

      // Change type back and verify
      manager.type = PeriodType.monthly;
      expect(manager.type, PeriodType.monthly);
      expect(manager.period, isNotNull);
    });

    test('goToPrevious Test - Monthly', () {
      PeriodManager manager = PeriodManager(PeriodType.monthly);

      // Store initial period
      Period initialPeriod = manager.period;

      // Call goToPrevious and verify period changed
      Period previousPeriod = manager.goToPrevious();
      expect(previousPeriod, isNotNull);
      expect(previousPeriod.startTimestamp < initialPeriod.startTimestamp, isTrue);
    });

    test('goToNext Test - Monthly', () {
      PeriodManager manager = PeriodManager(PeriodType.monthly);

      // Store initial period
      Period initialPeriod = manager.period;

      // Call goToNext and verify period changed
      Period nextPeriod = manager.goToNext();
      expect(nextPeriod, isNotNull);
      expect(nextPeriod.startTimestamp > initialPeriod.startTimestamp, isTrue);
    });

    test('goToPrevious Test - Annually', () {
      PeriodManager manager = PeriodManager(PeriodType.annually);

      // Store initial period
      Period initialPeriod = manager.period;

      // Call goToPrevious and verify period changed
      Period previousPeriod = manager.goToPrevious();
      expect(previousPeriod, isNotNull);
      expect(previousPeriod.startTimestamp < initialPeriod.startTimestamp, isTrue);
    });

    test('goToNext Test - Annually', () {
      PeriodManager manager = PeriodManager(PeriodType.annually);

      // Store initial period
      Period initialPeriod = manager.period;

      // Call goToNext and verify period changed
      Period nextPeriod = manager.goToNext();
      expect(nextPeriod, isNotNull);
      expect(nextPeriod.startTimestamp > initialPeriod.startTimestamp, isTrue);
    });
  });
}
