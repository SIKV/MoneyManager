import 'package:moneymanager/data/local/entity/transaction_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_type_entity.dart';
import 'package:moneymanager/data/mapping.dart';
import 'package:moneymanager/data/repository/wallets_repository.dart';
import 'package:moneymanager/domain/currency.dart';
import 'package:moneymanager/domain/wallet.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/transaction.dart';
import '../../domain/transaction_type.dart';
import '../../domain/transaction_type_filter.dart';
import '../../service/current_wallet_service.dart';
import '../local/datasource/transactions_local_data_source.dart';
import 'categories_repository.dart';

class TransactionsRepository {
  final TransactionsLocalDataSource localDataSource;
  final WalletsRepository walletsRepository;
  final CurrentWalletService currentWalletService;
  final CategoriesRepository categoriesRepository;

  final onUpdated = BehaviorSubject<Object>();

  TransactionsRepository(
      this.localDataSource,
      this.walletsRepository,
      this.currentWalletService,
      this.categoriesRepository);

  Future<void> addOrUpdate(Transaction transaction) async {
    Wallet? currentWallet = await currentWalletService.getCurrentWalletOrNull();
    if (currentWallet != null) {
      await localDataSource.addOrUpdate(transaction.toEntity(currentWallet.id));
      onUpdated.add(Object);
    }
  }

  Future<Transaction?> getById(int id) async {
    final transaction = await localDataSource.getById(id);
    if (transaction != null) {
      final currency = (await walletsRepository.getById(transaction.walletId))?.currency;
      if (currency != null) {
        return _mapTransaction(transaction, currency);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Stream<List<Transaction>> getAll({
    required TransactionTypeFilter typeFilter,
    required int fromTimestamp,
    int? toTimestamp,
  }) async* {

    Wallet? currentWallet = await currentWalletService.getCurrentWalletOrNull();
    TransactionTypeEntity? type;

    switch (typeFilter) {
      case TransactionTypeFilter.income:
        type = TransactionType.income.toEntity();
      case TransactionTypeFilter.expenses:
        type = TransactionType.expense.toEntity();
      case TransactionTypeFilter.all:
        type = null;
    }

    if (currentWallet == null) {
      yield* const Stream.empty();
    } else {
      yield* localDataSource.getAll(
        walletId: currentWallet.id,
        type: type,
        fromTimestamp: fromTimestamp,
        toTimestamp: toTimestamp ?? DateTime.now().millisecondsSinceEpoch,
      ).asyncMap((list) async {
        final mapped = list
            .map((it) => _mapTransaction(it, currentWallet.currency));

        return (await Future.wait(mapped))
            .whereType<Transaction>()
            .toList();
      });
    }
  }

  Future<List<Transaction>> findByContent(String query) async {
    Wallet? currentWallet = await currentWalletService.getCurrentWalletOrNull();

    if (currentWallet != null) {
      var list = await localDataSource.findByContent(currentWallet.id, query);
      final mapped = list
          .map((it) => _mapTransaction(it, currentWallet.currency));

      return (await Future.wait(mapped))
          .whereType<Transaction>()
          .toList();
    }
    return Future.error("Current wallet is not found.");
  }

  Future<void> delete(int id) async {
    await localDataSource.delete(id);
    onUpdated.add(Object);
  }

  Future<void> deleteByWalletId(int walletId) async {
    await localDataSource.deleteAllByWalletId(walletId);
    onUpdated.add(Object);
  }

  Future<void> deleteAllByCategoryId(int categoryId) async {
    await localDataSource.deleteAllByCategoryId(categoryId);
    onUpdated.add(Object);
  }

  Future<Transaction?> _mapTransaction(TransactionEntity entity, Currency currency) async {
    final category = await categoriesRepository.getById(entity.categoryId);

    if (category != null) {
      return entity.toDomain(category, currency);
    } else {
      return null;
    }
  }
}
