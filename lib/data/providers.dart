import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/data/local/providers.dart';
import 'package:moneymanager/data/repository/wallets_repository.dart';
import 'package:moneymanager/data/repository/categories_repository.dart';
import 'package:moneymanager/data/repository/transactions_repository.dart';

import '../local_preferences.dart';
import '../service/providers.dart';
import 'default/providers.dart';

final walletsRepositoryProvider = Provider((ref) async {
  final localDataSource = await ref.watch(walletsLocalDataSourceProvider);
  return WalletsRepository(localDataSource);
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
  final accountsRepository = await ref.watch(walletsRepositoryProvider);
  final currentAccountService = await ref.watch(currentWalletServiceProvider);
  final categoriesRepository = await ref.watch(categoriesRepositoryProvider);

  return TransactionsRepository(localDataSource, accountsRepository, currentAccountService, categoriesRepository);
});

final transactionsRepositoryUpdatedProvider = StreamProvider((ref) async* {
  final transactionsRepository = await ref.watch(transactionsRepositoryProvider);
  yield* transactionsRepository.onUpdated;
});
