import 'dart:async';

import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/account_entity.dart';
import 'package:moneymanager/data/local/entity/currency_entity.dart';

class AccountsLocalDataSource {
  final Isar isar;

  const AccountsLocalDataSource(this.isar);

  Future<void> add(AccountEntity account) async {
    return isar.writeTxn(() async {
      await isar.accountEntitys.put(account);
    });
  }

  Future<AccountEntity?> firstOrNull() async {
    return await isar.accountEntitys
        .where()
        .findFirst();
  }

  Future<AccountEntity?> getById(int id) async {
    return await isar.accountEntitys
        .where()
        .idEqualTo(id)
        .findFirst();
  }

  Future<List<AccountEntity>> getByCurrencyCode(String currencyCode) async {
    return await isar.accountEntitys
        .filter()
        .currency((q) => q.codeEqualTo(currencyCode))
        .findAll();
  }

  Future<List<AccountEntity>> getAll() async {
    return await isar.accountEntitys
        .where()
        .findAll();
  }

  Future<void> delete(int id) async {
    return isar.writeTxn(() async {
      await isar.accountEntitys
          .filter()
          .idEqualTo(id)
          .deleteAll();
    });
  }
}
