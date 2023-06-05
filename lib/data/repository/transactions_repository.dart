import 'package:moneymanager/data/local/entity/transaction_entity.dart';
import 'package:moneymanager/data/mapping.dart';
import 'package:moneymanager/domain/currency.dart';

import '../../domain/transaction.dart';
import '../../service/current_account_service.dart';
import '../local/datasource/transactions_local_data_source.dart';
import 'categories_repository.dart';

class TransactionsRepository {
  final TransactionsLocalDataSource localDataSource;
  final CategoriesRepository categoriesRepository;
  final CurrentAccountService currentAccountService;

  TransactionsRepository(this.localDataSource, this.categoriesRepository, this.currentAccountService);

  Future<void> addOrUpdate(Transaction transaction) async {
    return localDataSource.addOrUpdate(
        transaction.toEntity(currentAccountService.getCurrentAccountId())
    );
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

  Stream<List<Transaction>> getAll() {
    return localDataSource.getAll(currentAccountService.getCurrentAccountId())
        .asyncMap((list) async {
          final currency = (await currentAccountService.getCurrentAccount()).currency;
          final mapped = list.map((it) => _mapTransaction(it, currency));

          return (await Future.wait(mapped))
              .whereType<Transaction>()
              .toList();
        });
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
