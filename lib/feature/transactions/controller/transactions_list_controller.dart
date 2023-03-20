import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/data/providers.dart';

import '../domain/transaction_item_ui_model.dart';

final transactionsListControllerProvider = AsyncNotifierProvider<
    TransactionsListController, List<TransactionItemUiModel>>(() {
  return TransactionsListController();
});

class TransactionsListController extends AsyncNotifier<List<TransactionItemUiModel>> {

  @override
  FutureOr<List<TransactionItemUiModel>> build() async {
    final transactionsRepository = await ref.watch(
        transactionsRepositoryProvider.future);

    final transactions = await transactionsRepository.getAll();

    // TODO:

    final mapped = transactions.map((it) {
      return TransactionUiModel(
        id: it.id,
        emoji: it.category.emoji,
        title: it.category.title,
        subtitle: it.subcategory?.title,
        amount: it.amount.toString(),
      );
    });

    return mapped.toList();
  }
}
