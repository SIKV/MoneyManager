import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_type.dart';

import '../../../data/providers.dart';
import '../../../domain/transaction_category.dart';

final transactionCategoriesProvider = AsyncNotifierProvider
    .family.autoDispose<_TransactionCategoriesNotifier, List<TransactionCategory>, TransactionType>(() {
      return _TransactionCategoriesNotifier();
    });

class _TransactionCategoriesNotifier extends AutoDisposeFamilyAsyncNotifier<
    List<TransactionCategory>, TransactionType> {

  @override
  FutureOr<List<TransactionCategory>> build(TransactionType type) {
    return ref.read(categoriesRepositoryProvider)
        .getAllByType(type);
  }
}
