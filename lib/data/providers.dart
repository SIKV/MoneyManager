import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/data/local/providers.dart';
import 'package:moneymanager/data/repository/accounts_repository.dart';
import 'package:moneymanager/data/repository/categories_repository.dart';
import 'package:moneymanager/data/repository/transactions_repository.dart';
import 'package:moneymanager/local_preferences.dart';

import 'account_provider.dart';

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
  final accountProvider = await ref.watch(accountProviderProvider.future);

  return TransactionsRepository(localDataSource, categoriesRepository, accountProvider);
});

final accountProviderProvider = FutureProvider((ref) async {
  final accountsRepository = await ref.watch(accountsRepositoryProvider.future);
  final localPreferences = ref.watch(localPreferencesProvider);

  return AccountProvider(accountsRepository, localPreferences);
});
