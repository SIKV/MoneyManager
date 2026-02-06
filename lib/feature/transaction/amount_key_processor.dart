import '../../common/currency_formatter.dart';
import '../calculator/domain/amount_key.dart';

const _amountLengthLimit = 20;

sealed class AmountKeyProcessorResult { }

class AmountKeyProcessorAmountUpdate extends AmountKeyProcessorResult {
  final String amount;

  AmountKeyProcessorAmountUpdate(this.amount);
}

class AmountKeyProcessorCalculatorPress extends AmountKeyProcessorResult { }

class AmountKeyProcessorDonePress extends AmountKeyProcessorResult { }

class AmountKeyProcessor {

  bool hasDecimalPoint(String amount) {
    return amount.contains(AmountKey.decimal.char);
  }

  AmountKeyProcessorResult processAmountKey({
    required String currentAmount,
    required AmountKey key,
  }) {
    String amount = currentAmount;
    final canUpdateAmount = currentAmount.length < _amountLengthLimit;

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
          return AmountKeyProcessorCalculatorPress();
        case AmountKey.done:
          return AmountKeyProcessorDonePress();
        default:
          // Do nothing.
          break;
      }
    }

    return AmountKeyProcessorAmountUpdate(canUpdateAmount ? amount : currentAmount);
  }
}
