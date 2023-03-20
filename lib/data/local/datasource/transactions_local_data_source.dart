import 'dart:async';

import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/account_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_entity.dart';

class TransactionsLocalDataSource {
  final Isar isar;

  const TransactionsLocalDataSource(this.isar);

  Future<void> addOrUpdate(TransactionEntity transaction) async {
    return isar.writeTxn(() async {
      await isar.transactionEntitys.put(transaction);
    });
  }

  Future<List<TransactionEntity>> getAll(int accountId) async {
    return await isar.transactionEntitys
        .where()
        .findAll();
  }
}
