import 'dart:async';

import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/transaction_category_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_type_entity.dart';

class CategoriesLocalDataSource {
  final Isar isar;

  const CategoriesLocalDataSource(this.isar);

  Future<void> addOrUpdate(TransactionCategoryEntity category) async {
    return isar.writeTxn(() async {
      await isar.transactionCategoryEntitys.put(category);
    });
  }

  Future<TransactionCategoryEntity?> getById(int id) async {
    return await isar.transactionCategoryEntitys
        .where()
        .idEqualTo(id)
        .findFirst();
  }

  Future<List<TransactionCategoryEntity>> getAll(TransactionTypeEntity type, bool includeArchived) async {
    var query = isar.transactionCategoryEntitys
        .filter()
        .typeEqualTo(type);

    if (includeArchived) {
      return await query.findAll();
    } else {
      return await query
          .archivedEqualTo(false)
          .findAll();
    }
  }

  Future<bool> find(String title, TransactionTypeEntity type) async {
    return (await isar.transactionCategoryEntitys
        .filter()
        .typeEqualTo(type)
        .titleEqualTo(title, caseSensitive: false)
        .findAll())
        .isNotEmpty;
  }

  Future<void> delete(int id) async {
    return isar.writeTxn(() async {
      isar.transactionCategoryEntitys
          .filter()
          .idEqualTo(id)
          .deleteAll();
    });
  }
}
