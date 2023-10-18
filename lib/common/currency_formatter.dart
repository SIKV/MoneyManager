import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final currencyFormatterProvider = Provider((_) => CurrencyFormatter());

// TODO: Support locales.
class CurrencyFormatter {
  static const decimalDigits = 2;

  final _trailingZeros = RegExp(r'(?<=\.\d*?)0*$');
  final _trailingZerosWithDecimalPoint = RegExp(r'\.0*$');

  /// Note that this method will always remove the trailing zeros.
  /// If [alwaysShowDecimalPoint] is true the decimal point will always be visible
  /// even after removing the trailing zeros.
  String format(double amount, {
    bool compact = false,
    bool alwaysShowDecimalPoint = false,
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

    if (alwaysShowDecimalPoint) {
      formattedCurrency = formattedCurrency.replaceAll(_trailingZeros, '');
    } else {
      formattedCurrency = formattedCurrency.replaceAll(_trailingZerosWithDecimalPoint, '');
    }
    return formattedCurrency;
  }
}
