import '../../domain/transaction_category.dart';

abstract class CategoriesRepository {
  void addCategory(TransactionCategory category);
  Future<List<TransactionCategory>> getCategories();
}
