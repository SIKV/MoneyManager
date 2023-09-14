import 'package:moneymanager/data/local/datasource/categories_local_data_source.dart';
import 'package:moneymanager/data/mapping.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/transaction_type.dart';

class CategoriesRepository {
  final CategoriesLocalDataSource localDataSource;

  final onUpdated = BehaviorSubject<Object>();

  CategoriesRepository(this.localDataSource);

  Future<void> addOrUpdate(TransactionCategory category) async {
    await localDataSource.addOrUpdate(category.toEntity());
    onUpdated.add(Object);
  }

  Future<TransactionCategory?> getById(int id) async {
    final subcategory = await localDataSource.getById(id);
    return subcategory?.toDomain();
  }

  Future<List<TransactionCategory>> getAll(TransactionType type) async {
    final categories = await localDataSource.getAll(type.toEntity());

    return categories
        .map((it) => it.toDomain())
        .toList();
  }

  Future<void> delete(int id) async {
    await localDataSource.delete(id);
    onUpdated.add(Object);
  }
}
