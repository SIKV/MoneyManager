import 'package:intl/intl.dart';
import 'package:moneymanager/domain/transaction.dart';

import '../../common/currency_formatter.dart';
import '../../domain/transaction_type.dart';
import 'domain/transaction_item_ui_model.dart';

class TransactionUiModelMapper {
  final CurrencyFormatter _currencyFormatter;
  final _timeFormat = DateFormat(DateFormat.HOUR_MINUTE);

  TransactionUiModelMapper(this._currencyFormatter);

  List<TransactionUiModel> map(List<Transaction> transactions) {
    return transactions.map((it) {
      String amount = _currencyFormatter.format(
        it.amount,
        symbol: it.currency.symbol,
      );

      if (it.category.type == TransactionType.expense) {
        amount = '-$amount';
      }

      final time = _timeFormat.format(
        DateTime.fromMillisecondsSinceEpoch(it.createTimestamp),
      );
      final note = it.note?.trim();
      final subtitle = note == null || note.isEmpty ? time : '$time • $note';

      return TransactionUiModel(
        id: it.id,
        type: it.type,
        emoji: it.category.emoji,
        title: it.category.title,
        subtitle: subtitle,
        amount: amount,
      );
    }).toList();
  }
}
