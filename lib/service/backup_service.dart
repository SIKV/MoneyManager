import '../data/repository/accounts_repository.dart';
import '../data/repository/categories_repository.dart';
import '../data/repository/transactions_repository.dart';

class BackupService {
  final AccountsRepository accountsRepository;
  final CategoriesRepository categoriesRepository;
  final TransactionsRepository transactionsRepository;

  BackupService(
      this.accountsRepository,
      this.categoriesRepository,
      this.transactionsRepository,
  );

  void exportBackupFile() async {
    // TODO:
  }

  void importBackupFile() async {
    // TODO:
  }
}
