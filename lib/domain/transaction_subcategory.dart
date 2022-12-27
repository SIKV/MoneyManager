import 'package:flutter/widgets.dart';

@immutable
class TransactionSubcategory {
  final String id;
  final String title;

  const TransactionSubcategory({
    required this.id,
    required this.title,
  });

  TransactionSubcategory copyWith({
    String? title,
  }) {
    return TransactionSubcategory(
      id: id,
      title: title ?? this.title,
    );
  }
}
