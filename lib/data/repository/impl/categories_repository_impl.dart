import 'dart:async';

import 'package:moneymanager/domain/transaction_category.dart';

import '../categories_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  List<TransactionCategory> categories = [];

  @override
  void addOrUpdate(TransactionCategory category) {
    categories.add(category);
  }

  @override
  Future<List<TransactionCategory>> getAll() {
    return Future.value(categories);
  }

  @override
  void delete(String id) {
    categories.removeWhere((it) => it.id == id);
  }
}
