import 'package:moneymanager/data/local/entity/transaction_entity.dart';
import 'package:moneymanager/data/mapping.dart';
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
  final CategoriesRepository categoriesRepository;
  final CurrentAccountService currentAccountService;

  final onUpdated = BehaviorSubject<Object>();

  TransactionsRepository(this.localDataSource, this.categoriesRepository, this.currentAccountService);

  Future<void> addOrUpdate(Transaction transaction) async {
    await localDataSource.addOrUpdate(transaction.toEntity(currentAccountService.getCurrentAccountId()));
    onUpdated.add(Object);
  }

  Future<Transaction?> getById(int id) async {
    final transaction = await localDataSource.getById(id);
    final currency = (await currentAccountService.getCurrentAccount()).currency;

    if (transaction != null) {
      return _mapTransaction(transaction, currency);
    } else {
      return null;
    }
  }

  Stream<List<Transaction>> getAll({
    required TransactionTypeFilter typeFilter,
    required int fromTimestamp,
  }) {
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

    return localDataSource.getAll(
      accountId: currentAccountService.getCurrentAccountId(),
      fromTimestamp: fromTimestamp,
    ).asyncMap((list) async {
      final currency = (await currentAccountService.getCurrentAccount()).currency;
      final mapped = list
          .where(typeCondition)
          .map((it) => _mapTransaction(it, currency));

      return (await Future.wait(mapped))
          .whereType<Transaction>()
          .toList();
    });
  }

  Future<void> delete(int id) async {
    await localDataSource.delete(id);
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
