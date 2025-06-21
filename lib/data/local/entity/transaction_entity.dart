import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/transaction_type_entity.dart';

part 'transaction_entity.g.dart';

@Collection(ignore: {'props'})
class TransactionEntity extends Equatable {
  @Name('id')
  final Id id;

  @Index(composite: [CompositeIndex('createTimestamp')])
  @Name('walletId')
  final int walletId;

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

  String get searchContent {
    return "${note ?? ''} $amount";
  }

  const TransactionEntity({
    required this.id,
    required this.walletId,
    required this.createTimestamp,
    required this.type,
    required this.categoryId,
    required this.amount,
    required this.note,
  });

  TransactionEntity.fromJson(Map<String, dynamic> json) :
        id = json['id'] as Id,
        walletId = json['walletId'] as int,
        createTimestamp = json['createTimestamp'] as int,
        type = transactionTypeEntityFromString(json['type'] as String),
        categoryId = json['categoryId'] as int,
        amount = json['amount'] as double,
        note = json['note'] as String?;

  @override
  List<Object?> get props => [id];
}
