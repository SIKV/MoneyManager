import 'package:flutter_test/flutter_test.dart';
import 'package:moneymanager/common/currency_formatter.dart';
import 'package:moneymanager/domain/currency.dart';

void main() {
  group('CurrencyFormatter', () {
    final currencyFormatter = CurrencyFormatter();

    test('formats currency correctly with decimal point', () {
      const currency = Currency(code: 'USD', name: 'US Dollar', symbol: '\$', emoji: '');
      const amount = 1234.56;
      final result = currencyFormatter.format(currency: currency, amount: amount);
      expect(result, '\$1,234.56');
    });

    test('formats currency correctly without decimal point', () {
      const currency = Currency(code: 'JPY', name: 'Japanese Yen', symbol: '¥', emoji: '');
      const double amount = 1234;
      final result = currencyFormatter.format(currency: currency, amount: amount);
      expect(result, '¥1,234');
    });

    test('removes trailing zeros', () {
      const currency = Currency(code: 'EUR', name: 'Euro', symbol: '€', emoji: '');
      const double amount = 1234.5000;
      final result = currencyFormatter.format(currency: currency, amount: amount);
      expect(result, '€1,234.50');
    });

    test('always shows decimal point', () {
      const currency = Currency(code: 'GBP', name: 'British Pound', symbol: '£', emoji: '');
      const double amount = 1234;
      final result = currencyFormatter.format(currency: currency, amount: amount, alwaysShowDecimalPoint: true);
      expect(result, '£1,234.');
    });
  });
}
