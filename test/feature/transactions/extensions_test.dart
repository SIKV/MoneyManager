import 'package:flutter_test/flutter_test.dart';
import 'package:moneymanager/common/date_time_utils.dart';
import 'package:moneymanager/feature/transactions/domain/transaction_range_filter.dart';
import 'package:moneymanager/feature/transactions/extensions.dart';

// Unit tests here were partially or fully written by ChatGPT-3.5.
void main() {
  group('getFromTimestamp()', () {
    test('Should return the correct timestamp', () {
      final now = DateTime.now();

      expect(TransactionRangeFilter.day.getFromTimestamp(now), equals(subtractDay(now).millisecondsSinceEpoch));
      expect(TransactionRangeFilter.week.getFromTimestamp(now), equals(subtractWeek(now).millisecondsSinceEpoch));
      expect(TransactionRangeFilter.month.getFromTimestamp(now), equals(subtractMonth(now).millisecondsSinceEpoch));
      expect(TransactionRangeFilter.year.getFromTimestamp(now), equals(subtractYear(now).millisecondsSinceEpoch));
    });
  });
}
