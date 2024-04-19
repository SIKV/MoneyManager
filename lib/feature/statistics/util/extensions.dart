import '../../../domain/transaction_type.dart';
import '../../../domain/transaction_type_filter.dart';

extension TransactionTypeToTypeFilter on TransactionType {

  TransactionTypeFilter toTypeFilter() {
    switch (this) {
      case TransactionType.income:
        return TransactionTypeFilter.income;
      case TransactionType.expense:
        return TransactionTypeFilter.expenses;
    }
  }
}
