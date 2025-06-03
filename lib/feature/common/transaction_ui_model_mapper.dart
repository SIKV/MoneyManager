import 'package:moneymanager/domain/transaction.dart';

import '../../common/currency_formatter.dart';
import '../../domain/transaction_type.dart';
import 'domain/transaction_item_ui_model.dart';

class TransactionUiModelMapper {
  final CurrencyFormatter _currencyFormatter;

  TransactionUiModelMapper(this._currencyFormatter);

  List<TransactionUiModel> map(List<Transaction> transactions) {
    return transactions.map((it) {
      String amount = _currencyFormatter.format(it.amount);
      if (it.category.type == TransactionType.expense) {
        amount = '-$amount';
      }
      return TransactionUiModel(
        id: it.id,
        type: it.type,
        emoji: it.category.emoji,
        title: it.category.title,
        subtitle: it.note,
        amount: amount,
      );
    }).toList();
  }
}
