import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/domain/transaction_subcategory.dart';
import 'package:moneymanager/domain/transaction_type.dart';

part 'transaction.freezed.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required int createdAt, // Timestamp
    required TransactionType type,
    required TransactionCategory category,
    required TransactionSubcategory? subcategory,
    required double amount,
    required String? note,
  }) = _Transaction;
}
