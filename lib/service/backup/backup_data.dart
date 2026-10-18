import 'package:moneymanager/data/local/entity/transaction_category_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_entity.dart';
import 'package:moneymanager/data/local/entity/wallet_entity.dart';

/// Contents of a backup file that has been read and validated, but not yet written to the database.
class BackupData {
  final List<WalletEntity> wallets;
  final List<TransactionCategoryEntity> categories;
  final List<TransactionEntity> transactions;

  const BackupData({
    required this.wallets,
    required this.categories,
    required this.transactions,
  });
}
