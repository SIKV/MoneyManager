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
    final showArchived = state.value?.showArchived ?? false;

    final categoriesRepository = await ref.watch(categoriesRepositoryProvider);
    final categories = await categoriesRepository.getAll(selectedType, showArchived);

    return CategoriesState(
      types: TransactionType.values,
      selectedType: selectedType,
      categories: categories,
      showArchived: showArchived,
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

  void setShowArchived(bool showArchived) async {
    final currentState = await future;

    state = AsyncValue.data(
        currentState.copyWith(
          showArchived: showArchived,
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
    // Also delete all transactions with this categoryId.
    final transactionsRepository = await ref.watch(transactionsRepositoryProvider);
    await transactionsRepository.deleteAllByCategoryId(categoryId);

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
