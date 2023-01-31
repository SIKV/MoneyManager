import 'package:flutter/widgets.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/domain/transaction_subcategory.dart';
import 'package:moneymanager/domain/transaction_type.dart';

@immutable
class Transaction {
  final String id;
  final int createdAt; // Timestamp
  final TransactionType type;
  final TransactionCategory category;
  final TransactionSubcategory? subcategory;
  final double amount;
  final String? note;

  const Transaction({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.category,
    this.subcategory,
    required this.amount,
    this.note,
  });

  Transaction copyWith({
    int? createdAt,
    TransactionType? type,
    TransactionCategory? category,
    TransactionSubcategory? subcategory,
    double? amount,
    String? note,
  }) {
    return Transaction(
      id: id,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      amount: amount ?? this.amount,
      note: note ?? this.note,
    );
  }
}
