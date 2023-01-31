import 'package:moneymanager/domain/transaction_type.dart';

import '../../domain/transaction_category.dart';

abstract class CategoriesRepository {
  void addOrUpdate(TransactionCategory category);
  Future<List<TransactionCategory>> getAll();
  Future<List<TransactionCategory>> getAllByType(TransactionType type);
  void delete(String id);
}
