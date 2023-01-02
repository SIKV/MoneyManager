import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_category.dart';

import '../../data/providers.dart';

final categoriesListControllerProvider = AsyncNotifierProvider<CategoriesListController, List<TransactionCategory>>(() {
  return CategoriesListController();
});

class CategoriesListController extends AsyncNotifier<List<TransactionCategory>> {

  @override
  Future<List<TransactionCategory>> build() async {
    return ref.read(categoriesRepositoryProvider)
        .getCategories();
  }

  void addCategory(TransactionCategory category) {
    ref.read(categoriesRepositoryProvider)
        .addCategory(category);

    ref.invalidateSelf();
  }
}
