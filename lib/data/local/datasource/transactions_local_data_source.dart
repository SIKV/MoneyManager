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
    required int walletId,
    required TransactionTypeEntity? type,
    required int fromTimestamp,
    required int toTimestamp,
  }) {
    var query = isar.transactionEntitys
        .where()
        .walletIdEqualToCreateTimestampBetween(walletId, fromTimestamp, toTimestamp, includeLower: true, includeUpper: true);

    if (type != null) {
      return query
          .filter()
          .typeEqualTo(type)
          .watch(fireImmediately: true);
    } else {
      return query
          .watch(fireImmediately: true);
    }
  }

  Future<void> delete(int id) async {
    return isar.writeTxn(() async {
      await isar.transactionEntitys
          .where()
          .idEqualTo(id)
          .deleteAll();
    });
  }

  Future<void> deleteByWalletId(int walletId) async {
    return isar.writeTxn(() async {
      await isar.transactionEntitys
          .where()
          .walletIdEqualToAnyCreateTimestamp(walletId)
          .deleteAll();
    });
  }
}
