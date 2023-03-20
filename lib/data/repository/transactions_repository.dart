import 'package:collection/collection.dart';
import 'package:moneymanager/data/local/entity/transaction_entity.dart';
import 'package:moneymanager/data/mapping.dart';
import 'package:moneymanager/domain/currency.dart';

import '../../domain/transaction.dart';
import '../account_provider.dart';
import '../local/datasource/transactions_local_data_source.dart';
import 'categories_repository.dart';

class TransactionsRepository {
  final TransactionsLocalDataSource localDataSource;
  final CategoriesRepository categoriesRepository;
  final AccountProvider accountProvider;

  TransactionsRepository(this.localDataSource, this.categoriesRepository, this.accountProvider);

  Future<void> addOrUpdate(Transaction transaction) async {
    return localDataSource.addOrUpdate(
        transaction.toEntity(accountProvider.getCurrentAccountId())
    );
  }

  Future<List<Transaction>> getAll() async {
    final transactions = await localDataSource.getAll(accountProvider.getCurrentAccountId());
    final currency = (await accountProvider.getCurrentAccount()).currency;

    final mapped = transactions.map((it) => _mapTransaction(it, currency));

    return (await Future.wait(mapped))
        .whereType<Transaction>()
        .toList();
  }

  Future<Transaction?> _mapTransaction(TransactionEntity entity, Currency currency) async {
    final category = await categoriesRepository.getById(entity.categoryId);
    final subcategory = category?.subcategories.firstWhereOrNull((s) => entity.id == s.id);

    if (category != null) {
      return entity.toDomain(category, subcategory, currency);
    } else {
      return null;
    }
  }
}
