import 'package:flutter_test/flutter_test.dart';
import 'package:moneymanager/common/date_time_utils.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/transactions/domain/transaction_filter.dart';
import 'package:moneymanager/feature/transactions/extensions.dart';

// Unit tests here were partially or fully written by ChatGPT-3.5.
void main() {
  group('getTransactionType()', () {
    test('Should return TransactionType.income for income filters', () {
      // GIVEN
      final filters = [
        TransactionFilter.dayIncome,
        TransactionFilter.weekIncome,
        TransactionFilter.monthIncome,
        TransactionFilter.yearIncome,
      ];

      // WHEN
      // THEN
      for (final filter in filters) {
        expect(filter.getTransactionType(), equals(TransactionType.income));
      }
    });

    test('Should return TransactionType.expense for expense filters', () {
      // GIVEN
      final filters = [
        TransactionFilter.dayExpenses,
        TransactionFilter.weekExpenses,
        TransactionFilter.monthExpenses,
        TransactionFilter.yearExpenses,
      ];

      // WHEN
      // THEN
      for (final filter in filters) {
        expect(filter.getTransactionType(), equals(TransactionType.expense));
      }
    });
  });

  group('getFromTimestamp()', () {
    test('Should return the correct timestamp', () {
      final now = DateTime.now();

      expect(TransactionFilter.dayIncome.getFromTimestamp(now), equals(subtractDay(now).millisecondsSinceEpoch));
      expect(TransactionFilter.dayExpenses.getFromTimestamp(now), equals(subtractDay(now).millisecondsSinceEpoch));

      expect(TransactionFilter.weekIncome.getFromTimestamp(now), equals(subtractWeek(now).millisecondsSinceEpoch));
      expect(TransactionFilter.weekExpenses.getFromTimestamp(now), equals(subtractWeek(now).millisecondsSinceEpoch));

      expect(TransactionFilter.monthIncome.getFromTimestamp(now), equals(subtractMonth(now).millisecondsSinceEpoch));
      expect(TransactionFilter.monthExpenses.getFromTimestamp(now), equals(subtractMonth(now).millisecondsSinceEpoch));

      expect(TransactionFilter.yearIncome.getFromTimestamp(now), equals(subtractYear(now).millisecondsSinceEpoch));
      expect(TransactionFilter.yearExpenses.getFromTimestamp(now), equals(subtractYear(now).millisecondsSinceEpoch));
    });
  });
}
