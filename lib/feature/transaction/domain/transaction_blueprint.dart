import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/currency.dart';
import '../../../domain/transaction_category.dart';
import '../../../domain/transaction_subcategory.dart';
import '../../../domain/transaction_type.dart';

part 'transaction_blueprint.freezed.dart';

@freezed
class TransactionBlueprint with _$TransactionBlueprint {
  const factory TransactionBlueprint({
    required int id,
    required int createTimestamp,
    required String formattedCreateTimestamp,
    required TransactionType type,
    required TransactionCategory? category,
    required TransactionSubcategory? subcategory,
    required Currency currency,
    required double amount,
    required String formattedAmount,
    required String? note,
  }) = _TransactionBlueprint;
}
