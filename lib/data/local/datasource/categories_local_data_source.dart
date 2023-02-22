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

  Future<List<TransactionCategoryEntity>> getAll(TransactionTypeEntity type) async {
    final categories = await isar.transactionCategoryEntitys
        .filter()
        .typeEqualTo(type)
        .findAll();

    return categories;
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
