import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/transaction_item_ui_model.dart';

final transactionsListControllerProvider = AsyncNotifierProvider<
    _TransactionsListController, List<TransactionItemUiModel>>(() {
  return _TransactionsListController();
});

class _TransactionsListController extends AsyncNotifier<List<TransactionItemUiModel>> {

  @override
  FutureOr<List<TransactionItemUiModel>> build() {
    return [
      const TransactionSectionUiModel(title: 'Today'),
      const TransactionUiModel(
        id: '1',
        title: 'Title',
        subtitle: 'Subtitle',
        amount: '10',
        emoji: '🍔',
      ),
      const TransactionSectionUiModel(title: 'Yesterday'),
      const TransactionUiModel(
        id: '2',
        title: 'Title',
        subtitle: 'Subtitle',
        amount: '-50',
        emoji: '🙈',
      ),
    ];
  }
}
