import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/account_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_category_entity.dart';

import 'datasource/accounts_local_data_source.dart';
import 'datasource/categories_local_data_source.dart';

final accountsLocalDataSourceProvider = FutureProvider((_) async {
  final isar = await Isar.open([AccountEntitySchema]);
  return AccountsLocalDataSource(isar);
});

final categoriesLocalDataSourceProvider = FutureProvider((_) async {
  final isar = await Isar.open([TransactionCategoryEntitySchema]);
  return CategoriesLocalDataSource(isar);
});
