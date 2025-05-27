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

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get contentWords {
    // TODO: Add amount.
    return Isar.splitWords(note ?? '');
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

  @override
  List<Object?> get props => [id];
}
