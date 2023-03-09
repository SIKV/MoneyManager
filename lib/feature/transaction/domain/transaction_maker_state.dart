import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_property.dart';

import '../../../domain/transaction_category.dart';
import '../../../domain/transaction_subcategory.dart';
import '../../../domain/transaction_type.dart';

part 'transaction_maker_state.freezed.dart';

@freezed
class TransactionMakerState with _$TransactionMakerState {
  const factory TransactionMakerState({
    required String transactionId,
    required int createdAt,
    required TransactionType type,
    required TransactionCategory? category,
    required TransactionSubcategory? subcategory,
    required double amount,
    required String formattedAmount,
    required String? note,
    required TransactionProperty selectedProperty
  }) = _TransactionMakerState;
}
