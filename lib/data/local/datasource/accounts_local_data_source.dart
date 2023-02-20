import 'dart:async';

import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/account_entity.dart';

class AccountsLocalDataSource {
  final Isar isar;

  const AccountsLocalDataSource(this.isar);

  Future<void> addOrUpdate(AccountEntity account) async {
    return isar.writeTxn(() async {
      await isar.accountEntitys.put(account);
    });
  }

  Future<List<AccountEntity>> getAll() async {
    final accounts = await isar.accountEntitys
        .where()
        .findAll();

    return accounts;
  }
}
