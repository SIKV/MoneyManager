import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_type.dart';

import '../../../data/providers.dart';
import '../../../domain/transaction_category.dart';

final transactionCategoriesControllerProvider = AsyncNotifierProvider
    .family.autoDispose<TransactionCategoriesController, List<TransactionCategory>, TransactionType>(() {
      return TransactionCategoriesController();
    });

class TransactionCategoriesController extends AutoDisposeFamilyAsyncNotifier<
    List<TransactionCategory>, TransactionType> {

  @override
  FutureOr<List<TransactionCategory>> build(TransactionType arg) async {
    final categoriesRepository = await ref.watch(categoriesRepositoryProvider.future);
    return await categoriesRepository.getAll(arg);
  }
}
