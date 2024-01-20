import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/data/local/providers.dart';
import 'package:moneymanager/data/repository/accounts_repository.dart';
import 'package:moneymanager/data/repository/categories_repository.dart';
import 'package:moneymanager/data/repository/transactions_repository.dart';

import '../local_preferences.dart';
import '../service/providers.dart';
import 'default/providers.dart';

final accountsRepositoryProvider = Provider((ref) async {
  final localDataSource = await ref.watch(accountsLocalDataSourceProvider);
  return AccountsRepository(localDataSource);
});

final categoriesRepositoryProvider = Provider((ref) async {
  final localDataSource = await ref.watch(categoriesLocalDataSourceProvider);
  final defaultDataSource = ref.watch(categoriesDefaultDataSourceProvider);
  final localPreferences = ref.watch(localPreferencesProvider);

  return CategoriesRepository(localDataSource, defaultDataSource, localPreferences);
});

final categoriesRepositoryUpdatedProvider = StreamProvider((ref) async* {
  final categoriesRepository = await ref.watch(categoriesRepositoryProvider);
  yield* categoriesRepository.onUpdated;
});

final transactionsRepositoryProvider = Provider((ref) async {
  final localDataSource = await ref.watch(transactionsLocalDataSourceProvider);
  final accountsRepository = await ref.watch(accountsRepositoryProvider);
  final currentAccountService = await ref.watch(currentAccountServiceProvider);
  final categoriesRepository = await ref.watch(categoriesRepositoryProvider);

  return TransactionsRepository(localDataSource, accountsRepository, currentAccountService, categoriesRepository);
});

final transactionsRepositoryUpdatedProvider = StreamProvider((ref) async* {
  final transactionsRepository = await ref.watch(transactionsRepositoryProvider);
  yield* transactionsRepository.onUpdated;
});
