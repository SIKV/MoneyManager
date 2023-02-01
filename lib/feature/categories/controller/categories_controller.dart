import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/categories/domain/categories_state.dart';

import '../../../data/providers.dart';

final categoriesControllerProvider = AsyncNotifierProvider<_CategoriesController, CategoriesState>(() {
  return _CategoriesController();
});

class _CategoriesController extends AsyncNotifier<CategoriesState> {
  CategoriesState _state = const CategoriesState(
    types: TransactionType.values,
    selectedType: TransactionType.income,
    categories: [],
  );

  @override
  Future<CategoriesState> build() async {
    final categories = await ref.read(categoriesRepositoryProvider)
        .getAll(_state.selectedType);

    _state = _state.copyWith(
      categories: categories
    );
    return _state;
  }

  void selectType(int index) {
    _state = _state.copyWith(
      selectedType: _state.types[index]
    );
    ref.invalidateSelf();
  }

  void addOrUpdateCategory(TransactionCategory category) {
    ref.read(categoriesRepositoryProvider)
        .addOrUpdate(category);

    ref.invalidateSelf();
  }

  void deleteCategory(String categoryId) {
    ref.read(categoriesRepositoryProvider)
        .delete(categoryId);

    ref.invalidateSelf();
  }
}
