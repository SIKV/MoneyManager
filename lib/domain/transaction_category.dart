import 'package:flutter/widgets.dart';
import 'package:moneymanager/domain/transaction_subcategory.dart';
import 'package:moneymanager/domain/transaction_type.dart';

@immutable
class TransactionCategory {
  final String id;
  final TransactionType type;
  final String title;
  final String? emoji;
  final List<TransactionSubcategory> subcategories;

  const TransactionCategory({
    required this.id,
    required this.type,
    required this.title,
    this.emoji,
    this.subcategories = const [],
  });

  TransactionCategory copyWith({
    TransactionType? type,
    String? title,
    String? emoji,
    List<TransactionSubcategory>? subcategories,
  }) {
    return TransactionCategory(
      id: id,
      type: type ?? this.type,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      subcategories: subcategories ?? this.subcategories,
    );
  }
}
