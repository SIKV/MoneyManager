import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/account_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_category_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_entity.dart';
import 'package:path_provider/path_provider.dart';

import 'datasource/accounts_local_data_source.dart';
import 'datasource/categories_local_data_source.dart';
import 'datasource/transactions_local_data_source.dart';

final isarProvider = Provider((_) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open([
    AccountEntitySchema,
    TransactionCategoryEntitySchema,
    TransactionEntitySchema,
  ], directory: dir.path);
});

final accountsLocalDataSourceProvider = Provider((ref) async {
  final isar = await ref.watch(isarProvider);
  return AccountsLocalDataSource(isar);
});

final categoriesLocalDataSourceProvider = Provider((ref) async {
  final isar = await ref.watch(isarProvider);
  return CategoriesLocalDataSource(isar);
});

final transactionsLocalDataSourceProvider = Provider((ref) async {
  final isar = await ref.watch(isarProvider);
  return TransactionsLocalDataSource(isar);
});
