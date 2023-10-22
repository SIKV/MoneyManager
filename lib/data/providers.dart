import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/data/local/providers.dart';
import 'package:moneymanager/data/repository/accounts_repository.dart';
import 'package:moneymanager/data/repository/categories_repository.dart';
import 'package:moneymanager/data/repository/transactions_repository.dart';

import '../service/providers.dart';

final accountsRepositoryProvider = Provider((ref) async {
  final localDataSource = await ref.watch(accountsLocalDataSourceProvider);
  return AccountsRepository(localDataSource);
});

final categoriesRepositoryProvider = Provider((ref) async {
  final localDataSource = await ref.watch(categoriesLocalDataSourceProvider);
  return CategoriesRepository(localDataSource);
});

final categoriesRepositoryUpdatedProvider = StreamProvider((ref) async* {
  final categoriesRepository = await ref.watch(categoriesRepositoryProvider);
  yield* categoriesRepository.onUpdated;
});

final transactionsRepositoryProvider = Provider((ref) async {
  final localDataSource = await ref.watch(transactionsLocalDataSourceProvider);
  final categoriesRepository = await ref.watch(categoriesRepositoryProvider);
  final currentAccountService = await ref.watch(currentAccountServiceProvider);

  return TransactionsRepository(localDataSource, categoriesRepository, currentAccountService);
});

final transactionsRepositoryUpdatedProvider = StreamProvider((ref) async* {
  final transactionsRepository = await ref.watch(transactionsRepositoryProvider);
  yield* transactionsRepository.onUpdated;
});
