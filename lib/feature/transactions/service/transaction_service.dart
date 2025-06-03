import 'package:collection/collection.dart';
import 'package:moneymanager/common/date_time_utils.dart';
import 'package:moneymanager/data/repository/transactions_repository.dart';
import 'package:moneymanager/feature/transactions/extensions.dart';

import '../../../domain/transaction.dart';
import '../../../domain/transaction_type_filter.dart';
import '../../common/domain/transaction_item_ui_model.dart';
import '../../common/transaction_ui_model_mapper.dart';
import '../domain/transaction_range_filter.dart';

class TransactionService {
  final TransactionsRepository _transactionsRepository;
  final TransactionUiModelMapper _mapper;

  TransactionService(this._transactionsRepository, this._mapper);

  Stream<List<TransactionItemUiModel>> getFiltered(
      TransactionTypeFilter type, TransactionRangeFilter range) async* {

    int fromTimestamp = range.getFromTimestamp(DateTime.now());

    final transactions = _transactionsRepository.getAll(
      typeFilter: type,
      fromTimestamp: fromTimestamp,
    );

    yield* transactions.map((list) {
      return _insertSections(list);
    });
  }

  List<TransactionItemUiModel> _insertSections(List<Transaction> transactions) {
    // Sort by date (descending).
    var sorted = transactions.sortedByCompare((it) => it.createTimestamp, (a,
        b) => b.compareTo(a));

    // Group by date.
    var grouped = sorted.groupListsBy((it) {
      var dateTime = DateTime.fromMillisecondsSinceEpoch(it.createTimestamp);
      return DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          0,
          0,
          0,
          0,
          0);
    });

    List<TransactionItemUiModel> items = [];

    for (var entry in grouped.entries) {
      items.add(TransactionSectionUiModel(title: formatDate(entry.key)));
      items.addAll(_mapper.map(entry.value));
    }
    return items;
  }
}
