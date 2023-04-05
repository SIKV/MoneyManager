import '../../common/currency_formatter.dart';
import 'domain/amount_key.dart';

class AmountKeyProcessor {

  bool hasDecimalPoint(String amount) {
    return amount.contains(AmountKey.decimal.char);
  }

  String processAmountKey({
    required String currentAmount,
    required AmountKey key,
    required Function onCalculatorPressed,
    required Function onDonePressed,
  }) {
    String amount = currentAmount;

    if (key.isDigit) {
      final indexOfDecimal = amount.indexOf(AmountKey.decimal.char);
      if (indexOfDecimal != -1) {
        // If it already has {CurrencyFormatter.decimalDigits} digits after the decimal point.
        if (amount.length > indexOfDecimal + CurrencyFormatter.decimalDigits) {
          // Remove the last digit.
          amount = amount.substring(0, amount.length - 1);
        }
      }
      amount = amount + key.char;
    } else {
      switch (key) {
        case AmountKey.decimal:
          if (!hasDecimalPoint(amount)) {
            amount += key.char;
          }
          break;
        case AmountKey.backspace:
          if (amount.isNotEmpty) {
            amount = amount.substring(0, amount.length - 1);
          }
          break;
        case AmountKey.clear:
          amount = '';
          break;
        case AmountKey.calculator:
          onCalculatorPressed();
          break;
        case AmountKey.done:
          onDonePressed();
          break;
        default:
          // Do nothing.
          break;
      }
    }
    return amount;
  }
}
