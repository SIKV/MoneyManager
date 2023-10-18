import 'package:flutter_test/flutter_test.dart';
import 'package:moneymanager/common/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    final currencyFormatter = CurrencyFormatter();

    test('formats currency correctly with decimal point', () {
      const amount = 1234.56;
      final result = currencyFormatter.format(amount);
      expect(result, '1,234.56');
    });

    test('formats currency correctly in compact mode', () {
      const amount = 1000.0;
      final result = currencyFormatter.format(amount, compact: true);
      expect(result, '1K');
    });

    test('formats currency correctly without decimal point', () {
      const double amount = 1234;
      final result = currencyFormatter.format(amount);
      expect(result, '1,234');
    });

    test('removes trailing zeros', () {
      const double amount = 1234.5000;
      final result = currencyFormatter.format(amount);
      expect(result, '1,234.50');
    });

    test('always shows decimal point', () {
      const double amount = 1234;
      final result = currencyFormatter.format(amount, alwaysShowDecimalPoint: true);
      expect(result, '1,234.');
    });
  });
}
