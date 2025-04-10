import 'dart:async';

import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/wallet_entity.dart';
import 'package:moneymanager/data/local/entity/currency_entity.dart';

class WalletsLocalDataSource {
  final Isar isar;

  const WalletsLocalDataSource(this.isar);

  Future<void> add(WalletEntity account) async {
    return isar.writeTxn(() async {
      await isar.walletEntitys.put(account);
    });
  }

  Future<WalletEntity?> firstOrNull() async {
    return await isar.walletEntitys
        .where()
        .findFirst();
  }

  Future<WalletEntity?> getById(int id) async {
    return await isar.walletEntitys
        .where()
        .idEqualTo(id)
        .findFirst();
  }

  Future<List<WalletEntity>> getByCurrencyCode(String currencyCode) async {
    return await isar.walletEntitys
        .filter()
        .currency((q) => q.codeEqualTo(currencyCode))
        .findAll();
  }

  Future<List<WalletEntity>> getAll() async {
    return await isar.walletEntitys
        .where()
        .findAll();
  }

  Future<void> delete(int id) async {
    return isar.writeTxn(() async {
      await isar.walletEntitys
          .filter()
          .idEqualTo(id)
          .deleteAll();
    });
  }
}
