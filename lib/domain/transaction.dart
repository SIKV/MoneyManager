import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/domain/currency.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/domain/transaction_type.dart';

part 'transaction.freezed.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required int createTimestamp,
    required TransactionType type,
    required TransactionCategory category,
    required Currency currency,
    required double amount,
    required String? note,
  }) = _Transaction;
}
