import 'package:flutter_test/flutter_test.dart';
import 'package:moneymanager/common/date_time_utils.dart';
import 'package:moneymanager/feature/transactions/domain/transaction_range_filter.dart';
import 'package:moneymanager/feature/transactions/extensions.dart';

void main() {
  group('getFromTimestamp()', () {
    test('Should return the correct timestamp', () {
      final date = DateTime.utc(2024, 10, 5, 3, 50);

      final fromDay = DateTime.utc(2024, 10, 5, 0, 0);
      final fromWeek = DateTime.utc(2024, 9, 29, 0, 0);
      final fromMonth = DateTime.utc(2024, 10, 1, 0, 0);
      final fromYear = DateTime.utc(2024, 1, 1, 0, 0);

      expect(TransactionRangeFilter.day.getFromTimestamp(date), equals(fromDay.millisecondsSinceEpoch));
      expect(TransactionRangeFilter.week.getFromTimestamp(date), equals(fromWeek.millisecondsSinceEpoch));
      expect(TransactionRangeFilter.month.getFromTimestamp(date), equals(fromMonth.millisecondsSinceEpoch));
      expect(TransactionRangeFilter.year.getFromTimestamp(date), equals(fromYear.millisecondsSinceEpoch));
    });
  });
}
