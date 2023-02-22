import 'package:moneymanager/data/local/datasource/categories_local_data_source.dart';
import 'package:moneymanager/data/mapping.dart';
import 'package:moneymanager/domain/transaction_category.dart';

import '../../domain/transaction_type.dart';

class CategoriesRepository {
  final CategoriesLocalDataSource localDataSource;

  CategoriesRepository(this.localDataSource);

  Future<void> addOrUpdate(TransactionCategory category) async {
    return localDataSource.addOrUpdate(category.toEntity());
  }

  Future<List<TransactionCategory>> getAll(TransactionType type) async {
    final categories = await localDataSource.getAll(type.toEntity());

    return categories
        .map((it) => it.toDomain())
        .toList();
  }

  Future<void> delete(int id) async {
    return localDataSource.delete(id);
  }
}
