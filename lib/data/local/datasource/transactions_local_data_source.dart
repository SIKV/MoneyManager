import 'dart:async';

import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/transaction_entity.dart';

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
    required int walletId,
    required int fromTimestamp,
    required int toTimestamp,
  }) {
    return isar.transactionEntitys
        .filter()
        .walletIdEqualTo(walletId)
        .createTimestampGreaterThan(fromTimestamp, include: true)
        .createTimestampLessThan(toTimestamp, include: true)
        .watch(fireImmediately: true);
  }

  Future<void> delete(int id) async {
    return isar.writeTxn(() async {
      await isar.transactionEntitys
          .filter()
          .idEqualTo(id)
          .deleteAll();
    });
  }

  Future<void> deleteByWalletId(int accountId) async {
    return isar.writeTxn(() async {
      await isar.transactionEntitys
          .filter()
          .walletIdEqualTo(accountId)
          .deleteAll();
    });
  }
}
