import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/domain/transaction_type.dart';

part 'transaction_category.freezed.dart';

@freezed
class TransactionCategory with _$TransactionCategory {
  const factory TransactionCategory({
    required int id,
    required int createTimestamp,
    required TransactionType type,
    required String title,
    String? emoji,
  }) = _TransactionCategory;
}
