import '../../domain/transaction_category.dart';

abstract class CategoriesRepository {
  void addOrUpdate(TransactionCategory category);
  Future<List<TransactionCategory>> getAll();
  void delete(String id);
}
