import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/domain/transaction_category.dart';

import '../../../domain/transaction_type.dart';

part 'categories_state.freezed.dart';

@freezed
class CategoriesState with _$CategoriesState {
  const factory CategoriesState({
    required List<TransactionType> types,
    required TransactionType selectedType,
    required List<TransactionCategory> categories,
  }) = _CategoriesState;
}
