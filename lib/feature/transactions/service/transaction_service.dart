import 'package:moneymanager/common/currency_formatter.dart';
import 'package:moneymanager/data/repository/transactions_repository.dart';

import '../../../domain/transaction_type.dart';
import '../domain/transaction_filter.dart';
import '../domain/transaction_item_ui_model.dart';

class TransactionService {
  final TransactionsRepository _transactionsRepository;
  final CurrencyFormatter _currencyFormatter;

  TransactionService(this._transactionsRepository, this._currencyFormatter);

  Stream<List<TransactionUiModel>> getFiltered(TransactionFilter filter) async* {
    TransactionType type = TransactionType.income;
    int fromTimestamp = 0; // TODO: Set correct value.
    int toTimestamp = DateTime.now().millisecondsSinceEpoch; // TODO: Set correct value.

    switch (filter) {
      case TransactionFilter.dayIncome:
        type = TransactionType.income;
        break;
      case TransactionFilter.dayExpenses:
        type = TransactionType.expense;
        break;
      case TransactionFilter.weekIncome:
        type = TransactionType.income;
        break;
      case TransactionFilter.weekExpenses:
        type = TransactionType.expense;
        break;
      case TransactionFilter.monthIncome:
        type = TransactionType.income;
        break;
      case TransactionFilter.monthExpenses:
        type = TransactionType.expense;
        break;
      case TransactionFilter.yearIncome:
        type = TransactionType.income;
        break;
      case TransactionFilter.yearExpenses:
        type = TransactionType.expense;
        break;
    }

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
}
