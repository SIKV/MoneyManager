import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/feature/categories/domain/category_validation_error.dart';

import '../../../domain/transaction_category.dart';
import 'category_maker_mode.dart';

part 'category_maker_state.freezed.dart';

@freezed
class CategoryMakerState with _$CategoryMakerState {
  const factory CategoryMakerState({
    required CategoryMakerMode mode,
    required TransactionCategory category,
    required int titleMaxLength,
    required bool allowedToSave,
    required CategoryValidationError? validationError,
    required bool shouldPopPage,
  }) = _CategoryMakerState;
}
