import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/domain/transaction_subcategory.dart';
import 'package:moneymanager/domain/transaction_type.dart';

part 'transaction_category.freezed.dart';

@freezed
class TransactionCategory with _$TransactionCategory {
  const factory TransactionCategory({
    required String id,
    required TransactionType type,
    required String title,
    String? emoji,
    @Default([]) List<TransactionSubcategory> subcategories,
  }) = _TransactionCategory;
}
