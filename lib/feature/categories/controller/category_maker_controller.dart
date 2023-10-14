import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/utils.dart';

import '../../../domain/transaction_category.dart';
import '../domain/category_maker_args.dart';
import '../domain/category_maker_mode.dart';
import '../domain/category_maker_state.dart';
import 'categories_controller.dart';

final categoryMakerControllerProvider = NotifierProvider
    .autoDispose<CategoryMakerController, CategoryMakerState>(() {
  return CategoryMakerController();
});

class CategoryMakerController extends AutoDisposeNotifier<CategoryMakerState> {
  CategoryMakerMode? _mode;
  TransactionType? _initialType;
  TransactionCategory? _category;

  @override
  CategoryMakerState build() {
    final category = _getOrCreateCategory();

    return CategoryMakerState(
      mode: _mode ?? CategoryMakerMode.unknown,
      category: category,
      titleMaxLength: 56,
      allowedToSave: _isAllowedToSave(category),
      validationError: null,
    );
  }

  void initWithArgs(CategoryMakerArgs args) {
    if (args is AddCategoryMakerArgs) {
      _mode = CategoryMakerMode.add;
      _initialType = args.type;
    } else if (args is EditCategoryMakerArgs) {
      _mode = CategoryMakerMode.edit;
      _initialType = args.category.type;
      _category = args.category;
    } else {
      throw ArgumentError('Unexpected args: $args');
    }

    ref.invalidateSelf();
  }

  void setType(TransactionType transactionType) {
    state = state.copyWith(
      category: state.category.copyWith(
        type: transactionType,
      ),
    );
  }

  void setEmoji(String emoji) {
    state = state.copyWith(
      category: state.category.copyWith(
        emoji: emoji,
      ),
    );
  }

  void setTitle(String title) {
    final category = state.category.copyWith(
      title: title,
    );
    state = state.copyWith(
      category: category,
      allowedToSave: _isAllowedToSave(category),
    );
  }

  void save() {
    // TODO: Trim title.
    // TODO: Check if already exists.
    ref.read(categoriesControllerProvider.notifier)
        .addOrUpdateCategory(state.category);
  }

  void delete(bool withRelatedTransactions) {
    // TODO: Implement [withRelatedTransactions].
    ref.read(categoriesControllerProvider.notifier)
        .deleteCategory(state.category.id);
  }

  bool _isAllowedToSave(TransactionCategory category) {
    return category.title.trim().isNotEmpty;
  }

  TransactionCategory _getOrCreateCategory() {
    final category = _category;

    if (category != null) {
      return category;
    } else {
      return TransactionCategory(
        id: generateUniqueInt(),
        type: _initialType ?? TransactionType.income,
        title: '',
        emoji: null,
      );
    }
  }
}
