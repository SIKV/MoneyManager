import 'package:collection/collection.dart';
import 'package:moneymanager/data/local/datasource/categories_local_data_source.dart';
import 'package:moneymanager/data/mapping.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/transaction_type.dart';
import '../../local_preferences.dart';

class CategoriesRepository {
  final CategoriesLocalDataSource localDataSource;
  final LocalPreferences localPreferences;

  final onUpdated = BehaviorSubject<Object>();

  CategoriesRepository(this.localDataSource, this.localPreferences);

  Future<void> addOrUpdate(TransactionCategory category) async {
    await localDataSource.addOrUpdate(category.toEntity());
    onUpdated.add(Object);
  }

  Future<TransactionCategory?> getById(int id) async {
    final subcategory = await localDataSource.getById(id);
    return subcategory?.toDomain();
  }

  Future<List<TransactionCategory>> getAll(TransactionType type) async {
    final categoryEntities = await localDataSource.getAll(type.toEntity());
    final order = localPreferences.getCategoriesCustomOrder(type);

    return categoryEntities
        .map((it) => it.toDomain())
        .sorted((a, b) => _position(a, order).compareTo(_position(b, order))
    );
  }

  int _position(TransactionCategory category, List<String> order) {
    final position = order.indexOf(category.id.toString());

    if (position >= 0) {
      return position;
    } else {
      return category.createTimestamp;
    }
  }

  Future<void> delete(int id) async {
    await localDataSource.delete(id);
    onUpdated.add(Object);
  }

  void saveCustomOrder(List<TransactionCategory> categories, TransactionType type) {
    final order = categories
        .map((e) => e.id.toString())
        .toList();

    localPreferences.setCategoriesCustomOrder(order, type);
  }
}
