import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
abstract class TransactionItemUiModel {
  const TransactionItemUiModel();
}

@immutable
class TransactionUiModel extends TransactionItemUiModel {
  final int id;
  final String? emoji;
  final String title;
  final String? subtitle;
  final String amount;

  const TransactionUiModel({
    required this.id,
    this.emoji,
    required this.title,
    this.subtitle,
    required this.amount,
  });
}


@immutable
class TransactionSectionUiModel extends TransactionItemUiModel {
  final String title;

  const TransactionSectionUiModel({
    required this.title,
  });
}
