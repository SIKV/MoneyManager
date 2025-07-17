import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/utils.dart';

import '../../../data/providers.dart';
import '../../../domain/transaction_category.dart';
import '../domain/category_maker_args.dart';
import '../domain/category_maker_mode.dart';
import '../domain/category_maker_state.dart';
import '../domain/category_validation_error.dart';
import 'categories_controller.dart';

final categoryMakerControllerProvider = NotifierProvider
    .autoDispose<CategoryMakerController, CategoryMakerState>(() {
  return CategoryMakerController();
});

class CategoryMakerController extends AutoDisposeNotifier<CategoryMakerState> {
  CategoryMakerMode? _mode;
  TransactionType? _initialType;
  TransactionCategory? _initialCategory; // Note: this is not null only in CategoryMakerMode.edit

  @override
  CategoryMakerState build() {
    final category = _getOrCreateCategory();

    return CategoryMakerState(
      mode: _mode ?? CategoryMakerMode.unknown,
      category: category,
      titleMaxLength: 56,
      allowedToSave: _isAllowedToSave(category),
      validationError: null,
      shouldPopPage: false,
    );
  }

  void initWithArgs(CategoryMakerArgs args) {
    if (args is AddCategoryMakerArgs) {
      _mode = CategoryMakerMode.add;
      _initialType = args.type;
    } else if (args is EditCategoryMakerArgs) {
      _mode = CategoryMakerMode.edit;
      _initialType = args.category.type;
      _initialCategory = args.category;
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
      validationError: null,
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
      validationError: null,
    );
  }

  void save() async {
    final title = state.category.title.trim();

    // Check if the title is not empty.
    if (title.isEmpty) {
      state = state.copyWith(
        validationError: CategoryValidationError.emptyTitle,
      );
      return;
    }

    final category = state.category.copyWith(
      title: title,
    );

    switch (state.mode) {
      case CategoryMakerMode.unknown:
        // Do nothing.
        break;
      case CategoryMakerMode.add:
        _saveInAddMode(category);
        break;
      case CategoryMakerMode.edit:
        _saveInEditMode(category);
        break;
    }
  }

  void _saveInAddMode(TransactionCategory category) async {
    // Check if there's an existing category with the same [name] and [type] when trying to add a new one.
    final categoriesRepository = await ref.watch(categoriesRepositoryProvider);
    final alreadyExist = await categoriesRepository.find(
        category.title, category.type);

    if (alreadyExist) {
      state = state.copyWith(
        validationError: CategoryValidationError.alreadyExists,
      );
      return;
    } else {
      _save(category);
    }
  }

  void _saveInEditMode(TransactionCategory category) async {
    // Check if the category was edited.
    if (category != _initialCategory) {
      // If it was edited
      // and the title and type properties weren't edited
      // it can be saved without additional checks.
      if (category.title == _initialCategory?.title && category.type == _initialCategory?.type) {
        _save(category);
      } else {
        // Otherwise save with all the additional checks.
        _saveInAddMode(category);
      }
    } else {
      // If it wasn't edited just pop the page.
      state = state.copyWith(
        shouldPopPage: true,
      );
    }
  }

  void _save(TransactionCategory category) {
    ref.read(categoriesControllerProvider.notifier)
        .addOrUpdateCategory(category);

    state = state.copyWith(
      shouldPopPage: true,
    );
  }

  void delete() {
    ref.read(categoriesControllerProvider.notifier)
        .deleteCategory(state.category.id);
  }

  bool _isAllowedToSave(TransactionCategory category) {
    return category.title.trim().isNotEmpty;
  }

  TransactionCategory _getOrCreateCategory() {
    final category = _initialCategory;

    if (category != null) {
      return category;
    } else {
      return TransactionCategory(
        id: generateUniqueInt(),
        createTimestamp: DateTime.now().millisecondsSinceEpoch,
        type: _initialType ?? TransactionType.income,
        title: '',
        emoji: null,
      );
    }
  }
}
