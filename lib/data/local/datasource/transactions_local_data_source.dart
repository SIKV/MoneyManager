import 'dart:async';

import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/transaction_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_type_entity.dart';

class TransactionsLocalDataSource {
  final Isar isar;

  const TransactionsLocalDataSource(this.isar);

  Future<void> addOrUpdate(TransactionEntity transaction) async {
    return isar.writeTxn(() async {
      await isar.transactionEntitys.put(transaction);
    });
  }

  Future<TransactionEntity?> getById(int id) async {
    return await isar.transactionEntitys
        .where()
        .idEqualTo(id)
        .findFirst();
  }

  Stream<List<TransactionEntity>> getAll({
    required int accountId,
    required TransactionTypeEntity transactionType,
    required int fromTimestamp,
    required int toTimestamp,
  }) {
    return isar.transactionEntitys
        .filter()
        .accountIdEqualTo(accountId)
        .typeEqualTo(transactionType)
        .createTimestampBetween(fromTimestamp, toTimestamp, includeLower: true, includeUpper: true)
        .watch(fireImmediately: true);
  }
}
