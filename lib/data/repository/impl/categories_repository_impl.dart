import 'dart:async';

import 'package:moneymanager/domain/transaction_category.dart';

import '../../../domain/transaction_subcategory.dart';
import '../categories_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  List<TransactionCategory> categories = [
    const TransactionCategory(
        id: '1',
        title: 'Food',
        emoji: '🍔',
        subcategories: [
          TransactionSubcategory(id: '1', title: 'Subcategory 1'),
          TransactionSubcategory(id: '1', title: 'Subcategory 2'),
        ]
    ),
  ];

  @override
  void addCategory(TransactionCategory category) {
    categories.add(category);
  }

  @override
  Future<List<TransactionCategory>> getCategories() {
    return Future.value(categories);
  }
}
