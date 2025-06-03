import 'package:moneymanager/data/repository/categories_repository.dart';
import 'package:moneymanager/data/repository/transactions_repository.dart';
import 'package:moneymanager/domain/transaction.dart';

class SearchService {
  final TransactionsRepository transactionsRepository;
  final CategoriesRepository categoriesRepository;

  SearchService(this.transactionsRepository, this.categoriesRepository);

  Future<List<Transaction>> search(String query) async {
    // TODO: Add search by category title and combine it with the findByContent result.
    return transactionsRepository.findByContent(query);
  }
}
