import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moneymanager/utils.dart';

import '../../domain/transaction_category.dart';
import '../../domain/transaction_type.dart';

class CategoriesDefaultDataSource {
  final String path;

  const CategoriesDefaultDataSource(this.path);

  Future<List<TransactionCategory>> getAll(TransactionType type) async {
    final String jsonData = await rootBundle.loadString(path);
    final map = jsonDecode(jsonData) as Map<String, dynamic>;
    List<TransactionCategory> categories = [];

    for (var item in (map[_getName(type)] as List<dynamic>)) {
      categories.add(_fromJson(type, item as Map<String, dynamic>));
    }

    return categories;
  }

  String _getName(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return 'income';
      case TransactionType.expense:
        return 'expense';
    }
  }

  TransactionCategory _fromJson(TransactionType type, Map<String, dynamic> json) {
    return TransactionCategory(
      id: generateUniqueInt(),
      createTimestamp: DateTime.now().millisecondsSinceEpoch,
      type: type,
      title: json['title'] as String,
      emoji: json['emoji'] as String?,
      archived: false,
    );
  }
}
