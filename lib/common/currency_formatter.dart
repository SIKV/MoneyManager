import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final currencyFormatterProvider = Provider((_) => CurrencyFormatter());

// TODO: Support locales.

class CurrencyFormatter {
  static const decimalDigits = 2;

  final _trailingZerosWithDecimalPoint = RegExp(r'\.0*$');

  String format(double amount, {
    bool compact = false,
    bool removeTrailingZeros = true,
  }) {
    String formattedCurrency = '';

    if (compact) {
      formattedCurrency = NumberFormat.compactCurrency(
        symbol: '',
        decimalDigits: decimalDigits,
      ).format(amount);
    } else {
      formattedCurrency = NumberFormat.currency(
        symbol: '',
        decimalDigits: decimalDigits,
      ).format(amount);
    }

    if (removeTrailingZeros) {
      formattedCurrency = formattedCurrency.replaceAll(_trailingZerosWithDecimalPoint, '');
    }

    return formattedCurrency;
  }
}
