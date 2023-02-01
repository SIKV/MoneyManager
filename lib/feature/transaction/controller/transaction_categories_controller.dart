import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_type.dart';

import '../../../data/providers.dart';
import '../../../domain/transaction_category.dart';

final transactionCategoriesControllerProvider = AsyncNotifierProvider
    .family.autoDispose<_TransactionCategoriesController, List<TransactionCategory>, TransactionType>(() {
      return _TransactionCategoriesController();
    });

class _TransactionCategoriesController extends AutoDisposeFamilyAsyncNotifier<
    List<TransactionCategory>, TransactionType> {

  @override
  FutureOr<List<TransactionCategory>> build(TransactionType type) {
    return ref.read(categoriesRepositoryProvider)
        .getAllByType(type);
  }
}
