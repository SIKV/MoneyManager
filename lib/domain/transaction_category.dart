import 'package:flutter/widgets.dart';
import 'package:moneymanager/domain/transaction_subcategory.dart';

@immutable
class TransactionCategory {
  final String id;
  final String title;
  final String? emoji;
  final List<TransactionSubcategory> subcategories;

  const TransactionCategory({
    required this.id,
    required this.title,
    this.emoji,
    this.subcategories = const [],
  });

  TransactionCategory copyWith({
    String? title,
    String? emoji,
    List<TransactionSubcategory>? subcategories,
  }) {
    return TransactionCategory(
      id: id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      subcategories: subcategories ?? this.subcategories,
    );
  }
}
