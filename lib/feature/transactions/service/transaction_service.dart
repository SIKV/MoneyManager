import 'package:moneymanager/common/currency_formatter.dart';
import 'package:moneymanager/common/date_time_utils.dart';
import 'package:moneymanager/data/repository/transactions_repository.dart';

import '../../../domain/transaction_type.dart';
import '../domain/transaction_filter.dart';
import '../domain/transaction_item_ui_model.dart';

class TransactionService {
  final TransactionsRepository _transactionsRepository;
  final CurrencyFormatter _currencyFormatter;

  TransactionService(this._transactionsRepository, this._currencyFormatter);

  Stream<List<TransactionUiModel>> getFiltered(TransactionFilter filter) async* {
    TransactionType type = _getTransactionType(filter);
    int fromTimestamp = _getFromTimestamp(filter);
    int toTimestamp = DateTime.now().millisecondsSinceEpoch;

    final transactions = _transactionsRepository.getAll(
      type: type,
      fromTimestamp: fromTimestamp,
      toTimestamp: toTimestamp,
    ).map((list) {
      return list.map((it) {
        return TransactionUiModel(
          id: it.id,
          emoji: it.category.emoji,
          title: it.category.title,
          amount: _currencyFormatter.format(
            currency: it.currency,
            amount: it.amount,
          ),
        );
      }).toList();
    });

    yield* transactions;
  }

  TransactionType _getTransactionType(TransactionFilter filter) {
    TransactionType type = TransactionType.income;

    switch (filter) {
      case TransactionFilter.dayIncome:
      case TransactionFilter.weekIncome:
      case TransactionFilter.monthIncome:
      case TransactionFilter.yearIncome:
        type = TransactionType.income;
        break;
      case TransactionFilter.dayExpenses:
      case TransactionFilter.weekExpenses:
      case TransactionFilter.monthExpenses:
      case TransactionFilter.yearExpenses:
        type = TransactionType.expense;
        break;
    }

    return type;
  }

  int _getFromTimestamp(TransactionFilter filter) {
    var fromDateTime = DateTime.now();

    switch (filter) {
      case TransactionFilter.dayIncome:
      case TransactionFilter.dayExpenses:
        fromDateTime = subtractDay(fromDateTime);
        break;
      case TransactionFilter.weekIncome:
      case TransactionFilter.weekExpenses:
        fromDateTime = subtractWeek(fromDateTime);
        break;
      case TransactionFilter.monthIncome:
      case TransactionFilter.monthExpenses:
        fromDateTime = subtractMonth(fromDateTime);
        break;
      case TransactionFilter.yearIncome:
      case TransactionFilter.yearExpenses:
        fromDateTime = subtractYear(fromDateTime);
        break;
    }

    return fromDateTime.millisecondsSinceEpoch;
  }
}
