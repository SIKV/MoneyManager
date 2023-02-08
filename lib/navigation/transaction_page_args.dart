import 'package:moneymanager/domain/transaction_type.dart';

import '../domain/transaction.dart';

class TransactionPageArgs {
  final Transaction? transaction;
  final TransactionType? type;

  TransactionPageArgs({
    this.transaction,
    this.type,
  });
}
