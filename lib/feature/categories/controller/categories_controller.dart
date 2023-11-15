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

    final categoriesRepository = await ref.watch(categoriesRepositoryProvider);
    final categories = await categoriesRepository.getAll(selectedType);

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
    final categoriesRepository = await ref.watch(categoriesRepositoryProvider);
    await categoriesRepository.addOrUpdate(category);

    ref.invalidateSelf();
  }

  void deleteCategory(int categoryId) async {
    final categoriesRepository = await ref.watch(categoriesRepositoryProvider);
    await categoriesRepository.delete(categoryId);

    ref.invalidateSelf();
  }

  void reorder(TransactionCategory category, int oldIndex, int newIndex) async {
    final currentState = await future;
    final reorderedCategories = currentState.categories.toList();

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = reorderedCategories.removeAt(oldIndex);
    reorderedCategories.insert(newIndex, item);

    final categoriesRepository = await ref.watch(categoriesRepositoryProvider);
    categoriesRepository.saveCustomOrder(reorderedCategories, currentState.selectedType);

    state = AsyncValue.data(
      currentState.copyWith(
        categories: reorderedCategories,
      )
    );
  }
}
