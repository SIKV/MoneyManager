import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/domain/transaction_type.dart';

@immutable
abstract class TransactionItemUiModel {
  const TransactionItemUiModel();
}

@immutable
class TransactionUiModel extends TransactionItemUiModel {
  final int id;
  final TransactionType type;
  final String? emoji;
  final String title;
  final String? subtitle;
  final String amount;

  const TransactionUiModel({
    required this.id,
    required this.type,
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
