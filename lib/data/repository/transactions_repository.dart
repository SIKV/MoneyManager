import 'package:moneymanager/data/local/entity/transaction_entity.dart';
import 'package:moneymanager/data/mapping.dart';
import 'package:moneymanager/data/repository/accounts_repository.dart';
import 'package:moneymanager/domain/account.dart';
import 'package:moneymanager/domain/currency.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/transaction.dart';
import '../../domain/transaction_type.dart';
import '../../domain/transaction_type_filter.dart';
import '../../service/current_account_service.dart';
import '../local/datasource/transactions_local_data_source.dart';
import 'categories_repository.dart';

class TransactionsRepository {
  final TransactionsLocalDataSource localDataSource;
  final AccountsRepository accountsRepository;
  final CurrentAccountService currentAccountService;
  final CategoriesRepository categoriesRepository;

  final onUpdated = BehaviorSubject<Object>();

  TransactionsRepository(
      this.localDataSource,
      this.accountsRepository,
      this.currentAccountService,
      this.categoriesRepository);

  Future<void> addOrUpdate(Transaction transaction) async {
    Account? currentAccount = await currentAccountService.getCurrentAccountOrNull();
    if (currentAccount != null) {
      await localDataSource.addOrUpdate(transaction.toEntity(currentAccount.id));
      onUpdated.add(Object);
    }
  }

  Future<Transaction?> getById(int id) async {
    final transaction = await localDataSource.getById(id);
    if (transaction != null) {
      final currency = (await accountsRepository.getById(transaction.accountId))?.currency;
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
  }) async* {
    typeCondition(TransactionEntity e) {
      switch (typeFilter) {
        case TransactionTypeFilter.income:
          return e.type == TransactionType.income.toEntity();
        case TransactionTypeFilter.expenses:
          return e.type == TransactionType.expense.toEntity();
        case TransactionTypeFilter.all:
          return true;
      }
    }

    Account? currentAccount = await currentAccountService.getCurrentAccountOrNull();

    if (currentAccount == null) {
      yield* const Stream.empty();
    } else {
      yield* localDataSource.getAll(
        accountId: currentAccount.id,
        fromTimestamp: fromTimestamp,
      ).asyncMap((list) async {
        final mapped = list
            .where(typeCondition)
            .map((it) => _mapTransaction(it, currentAccount.currency));

        return (await Future.wait(mapped))
            .whereType<Transaction>()
            .toList();
      });
    }
  }

  Future<void> delete(int id) async {
    await localDataSource.delete(id);
    onUpdated.add(Object);
  }

  Future<void> deleteByAccountId(int accountId) async {
    await localDataSource.deleteByAccountId(accountId);
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
