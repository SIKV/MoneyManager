import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/transaction_subcategory_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_type_entity.dart';

part 'transaction_entity.g.dart';

@Collection(ignore: {'props'})
class TransactionEntity extends Equatable {
  @Name('id')
  final Id id;

  @Name('accountId')
  final int accountId;

  @Name('createTimestamp')
  final int createTimestamp;

  @Name('type')
  @Enumerated(EnumType.name)
  final TransactionTypeEntity type;

  @Name('categoryId')
  final int categoryId;

  @Name('amount')
  final double amount;

  @Name('note')
  final String? note;

  const TransactionEntity({
    required this.id,
    required this.accountId,
    required this.createTimestamp,
    required this.type,
    required this.categoryId,
    required this.amount,
    required this.note,
  });

  @override
  List<Object?> get props => [id];
}
