import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/categories/domain/categories_state.dart';

import '../../../data/providers.dart';

final categoriesControllerProvider = AsyncNotifierProvider<CategoriesController, CategoriesState>(() {
  return CategoriesController();
});

class CategoriesController extends AsyncNotifier<CategoriesState> {

  @override
  Future<CategoriesState> build() async {
    final selectedType = state.value?.selectedType ?? TransactionType.income;

    final categoriesRepository = await ref.watch(categoriesRepositoryProvider.future);
    final categories = await categoriesRepository.getAll(selectedType);

    // TODO: Get order from preferences.

    return CategoriesState(
      types: TransactionType.values,
      selectedType: selectedType,
      categories: categories,
    );
  }

  void selectType(TransactionType type) async {
    final currentState = await future;

    state = AsyncValue.data(
      currentState.copyWith(
        selectedType: type,
      )
    );

    ref.invalidateSelf();
  }

  void addOrUpdateCategory(TransactionCategory category) async {
    final categoriesRepository = await ref.watch(categoriesRepositoryProvider.future);
    await categoriesRepository.addOrUpdate(category);

    ref.invalidateSelf();
  }

  void deleteCategory(int categoryId) async {
    final categoriesRepository = await ref.watch(categoriesRepositoryProvider.future);
    await categoriesRepository.delete(categoryId);

    ref.invalidateSelf();
  }

  void reorder(TransactionCategory category, int oldIndex, int newIndex) async {
    final currentState = await future;

    final categories = currentState.categories.toList();

    if (oldIndex < newIndex) {
      newIndex = -1;
    }

    final item = categories.removeAt(oldIndex);
    categories.insert(newIndex, item);

    // TODO: Save order in preferences.

    state = AsyncValue.data(
      currentState.copyWith(
        categories: categories,
      )
    );
  }
}
