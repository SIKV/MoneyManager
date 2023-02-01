import 'dart:async';

import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/domain/transaction_type.dart';

import '../categories_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  List<TransactionCategory> categories = [];

  @override
  void addOrUpdate(TransactionCategory category) {
    categories.add(category);
  }

  @override
  Future<List<TransactionCategory>> getAll(TransactionType type) {
    final filteredCategories = categories.where((it) => it.type == type).toList();
    return Future.value(filteredCategories);
  }

  @override
  void delete(String id) {
    categories.removeWhere((it) => it.id == id);
  }
}
