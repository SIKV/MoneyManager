import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/data/local/providers.dart';
import 'package:moneymanager/data/repository/accounts_repository.dart';
import 'package:moneymanager/data/repository/categories_repository.dart';
import 'package:moneymanager/data/repository/transactions_repository.dart';

import '../service/providers.dart';

final accountsRepositoryProvider = FutureProvider((ref) async {
  final localDataSource = await ref.watch(accountsLocalDataSourceProvider.future);
  return AccountsRepository(localDataSource);
});

final categoriesRepositoryProvider = FutureProvider((ref) async {
  final localDataSource = await ref.watch(categoriesLocalDataSourceProvider.future);
  return CategoriesRepository(localDataSource);
});

final transactionsRepositoryProvider = FutureProvider((ref) async {
  final localDataSource = await ref.watch(transactionsLocalDataSourceProvider.future);
  final categoriesRepository = await ref.watch(categoriesRepositoryProvider.future);
  final currentAccountService = await ref.watch(currentAccountServiceProvider.future);

  return TransactionsRepository(localDataSource, categoriesRepository, currentAccountService);
});
